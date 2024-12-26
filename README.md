# Dotfiles

Personal dotfiles for development environments and devcontainers.

## Tools
[] AstroVIM
[] Nix & Felx
[] Docker (Conditional)
[] Webinstaller (https://webinstall.dev/)
[] DevContainer


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
