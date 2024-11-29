#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print with color
print_color() {
    color=$1
    message=$2
    printf "${color}${message}${NC}\n"
}

# Error handling
set -e
trap 'print_color $RED "Error: Command failed at line $LINENO"' ERR

# Create base directory
DOTFILES_DIR="/workspace/dotfiles"
print_color $BLUE "Creating dotfiles directory at $DOTFILES_DIR..."
# mkdir -p "$DOTFILES_DIR"
cd "$DOTFILES_DIR"

# Initialize git repository
print_color $BLUE "Initializing git repository..."
git init

# Create directory structure
print_color $BLUE "Creating directory structure..."
mkdir -p .github/workflows
mkdir -p devcontainer
mkdir -p git
mkdir -p tmux
mkdir -p vim
mkdir -p zsh

# Create install.sh
print_color $BLUE "Creating install.sh..."
cat > install.sh << 'EOF'
#!/bin/bash
# install.sh - Dotfiles installation script

# Create necessary directories
mkdir -p ~/.config
mkdir -p ~/.local/bin

# Symlink configuration files
ln -sf $(pwd)/zsh/.zshrc ~/.zshrc
ln -sf $(pwd)/git/.gitconfig ~/.gitconfig
ln -sf $(pwd)/vim/.vimrc ~/.vimrc
ln -sf $(pwd)/tmux/.tmux.conf ~/.tmux.conf
ln -sf $(pwd)/devcontainer/global-devcontainer.json ~/.devcontainer.json

# Install basic dependencies (customize based on your needs)
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y \
        zsh \
        vim \
        tmux \
        git \
        curl \
        wget
elif command -v brew &> /dev/null; then
    brew install \
        zsh \
        vim \
        tmux \
        git \
        curl \
        wget
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Source the new configurations
source ~/.zshrc

echo "Dotfiles installation complete!"
EOF
chmod +x install.sh

# Create .gitconfig
print_color $BLUE "Creating git configuration..."
cat > git/.gitconfig << 'EOF'
[user]
    name = Rahul V Ramesh
    email = rahulvramesh@example.com

[core]
    editor = vim
    excludesfile = ~/.gitignore_global
    autocrlf = input

[init]
    defaultBranch = main

[pull]
    rebase = false

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

[color]
    ui = auto

[credential]
    helper = cache --timeout=3600
EOF

# Create .zshrc
print_color $BLUE "Creating zsh configuration..."
cat > zsh/.zshrc << 'EOF'
# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    docker
    docker-compose
    kubectl
    node
    npm
    python
    vscode
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='vim'
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias dotfiles="cd $HOME/dotfiles"
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias docker-clean="docker system prune -af"

# Custom functions
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# DevContainer specific configurations
if [ -f "/.dockerenv" ]; then
    # Inside container specific settings
    export TERM=xterm-256color
fi

# Local customizations
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
EOF

# Create global-devcontainer.json
print_color $BLUE "Creating DevContainer configuration..."
cat > devcontainer/global-devcontainer.json << 'EOF'
{
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode-remote.remote-containers",
                "ms-azuretools.vscode-docker",
                "dbaeumer.vscode-eslint",
                "esbenp.prettier-vscode",
                "GitHub.copilot",
                "eamodio.gitlens",
                "ms-python.python",
                "ms-python.vscode-pylance"
            ],
            "settings": {
                "terminal.integrated.defaultProfile.linux": "zsh",
                "editor.formatOnSave": true,
                "editor.rulers": [80, 100],
                "files.trimTrailingWhitespace": true,
                "files.insertFinalNewline": true
            }
        }
    },
    "features": {
        "ghcr.io/devcontainers/features/docker-in-docker:2": {},
        "ghcr.io/devcontainers/features/github-cli:1": {},
        "ghcr.io/devcontainers/features/node:1": {
            "version": "lts"
        },
        "ghcr.io/devcontainers/features/python:1": {
            "version": "3.10"
        }
    },
    "postCreateCommand": "bash ${containerWorkspaceFolder}/.devcontainer/post-create.sh"
}
EOF

# Create post-create.sh
print_color $BLUE "Creating post-create script..."
cat > devcontainer/post-create.sh << 'EOF'
#!/bin/bash

# Install additional dependencies
npm install -g typescript ts-node

# Set up git configuration
git config --global core.editor "code --wait"

# Install oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
EOF
chmod +x devcontainer/post-create.sh

# Create README.md
print_color $BLUE "Creating README..."
cat > README.md << 'EOF'
# Dotfiles

Personal dotfiles for development environments and devcontainers.

## Installation

```bash
git clone https://github.com/rahulvramesh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Features

- Zsh configuration with Oh My Zsh
- Git configuration with useful aliases
- DevContainer configurations for VS Code
- Tmux configuration
- Vim configuration

## Structure

```
dotfiles/
├── .github/
│   └── workflows/
├── devcontainer/
├── git/
├── tmux/
├── vim/
├── zsh/
├── install.sh
└── README.md
```

## Usage with DevContainers

Add to your VS Code settings.json:
```json
{
    "dotfiles.repository": "rahulvramesh/dotfiles",
    "dotfiles.targetPath": "~/dotfiles",
    "dotfiles.installCommand": "~/dotfiles/install.sh"
}
```
EOF

# Create GitHub Actions workflow
print_color $BLUE "Creating GitHub Actions workflow..."
cat > .github/workflows/test.yml << 'EOF'
name: Test Dotfiles Installation

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Test installation script
        run: |
          ./install.sh
EOF

# Create .gitignore
print_color $BLUE "Creating .gitignore..."
cat > .gitignore << 'EOF'
.DS_Store
*.log
*.swp
*~
.idea/
.vscode/
EOF

# Initialize git repository
print_color $BLUE "Setting up git repository..."
git add .
git commit -m "Initial commit"

# Instructions to set up remote repository
print_color $GREEN "Dotfiles repository has been created successfully!"
print_color $BLUE "Next steps:"
echo "1. Create a new repository at https://github.com/rahulvramesh/dotfiles"
echo "2. Run the following commands:"
echo "   git remote add origin https://github.com/rahulvramesh/dotfiles.git"
echo "   git push -u origin main"

print_color $GREEN "Done! Your dotfiles repository is ready to use."