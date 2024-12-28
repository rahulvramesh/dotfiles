#!/bin/bash

# Function to check if running in Docker
is_docker() {
    if [ -f /.dockerenv ] || grep -q 'docker\|lxc' /proc/1/cgroup; then
        echo "Docker environment detected"
        return 0
    fi
    return 1
}

# Function to detect OS and update system
update_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VERSION=$VERSION_ID
        
        case $OS in
            "Ubuntu"|"Debian GNU/Linux")
                echo "Detected: $OS $VERSION"
                
                # Check if running in Docker
                if is_docker; then
                    echo "Skipping system update in Docker environment"
                    return 0
                fi
                
                echo "Updating system packages..."
                sudo apt update && sudo apt upgrade -y
                
                # Check if update was successful
                if [ $? -eq 0 ]; then
                    echo "System update completed successfully"
                    return 0
                else
                    echo "Error: System update failed"
                    return 1
                fi
                ;;
            *)
                echo "This is not Ubuntu or Debian. Detected: $OS"
                return 1
                ;;
        esac
    else
        echo "Cannot detect OS: /etc/os-release file not found"
        return 1
    fi
}

# Run the update
if ! update_system; then
    echo "System update failed. Exiting..."
    exit 1
fi

# Copy The Files
# TODO:

# Install Basic Packages Using web installer
sudo apt install -y curl git zsh make unzip ripgrep cargo

curl -sS https://webi.sh/webi | sh

if [ -f ~/.config/envman/PATH.env ]; then
        . ~/.config/envman/PATH.env
    else
        echo "Warning: PATH.env not found. You may need to restart your shell."
fi

# Install the packages
webi bat fd jq delta gh k9s node pyenv

# Install Zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

echo "Proceeding with further installations..."
