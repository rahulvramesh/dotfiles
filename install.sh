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
    echo "y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Change default shell to zsh if not already
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s $(which zsh)
fi

# Node Version Manager installation and setup
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Add to ~/.zshrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install latest LTS version of Node.js
nvm install --lts
nvm use --lts

# Source the new configurations
source ~/.zshrc

echo "Dotfiles installation complete!"
