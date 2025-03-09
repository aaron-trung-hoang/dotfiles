#!/bin/bash

# Function to install common tools (e.g., zsh)
install_common() {
    echo "Installing common tools (e.g., zsh)..."
    chmod +x ./install_common.sh
    ./install_common.sh
}

# Function to handle macOS with Homebrew
install_macos_brew() {
    echo "macos-brew selected. Add your installation commands here."
}

# Function to handle Ubuntu
install_ubuntu() {
    echo "ubuntu selected. Add your installation commands here."
    
    sudo apt update
    chmod +x ./ubuntu/install_packages.sh
    ./ubuntu/install_packages.sh
}

# Function to handle WSL
install_wsl() {
    echo "wsl selected. Add your installation commands here."
}

# Main script
echo "Select your environment:"
echo "1) macos-brew"
echo "2) ubuntu"
echo "3) wsl"
read -p "Enter your choice (macos-brew/ubuntu/wsl): " choice

case "$choice" in
    "macos-brew")
        install_macos_brew
        install_common
        ;;
    "ubuntu")
        install_ubuntu
        install_common
        ;;
    "wsl")
        install_wsl
        install_common
        ;;
    *)
        echo "Invalid choice. Please enter 'macos-brew', 'ubuntu', or 'wsl'."
        exit 1
        ;;
esac

echo "Setup completed."
