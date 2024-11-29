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
