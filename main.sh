#!/bin/bash

set -e  # Exit on error

# Source platform utilities
source "$(dirname "$0")/lib/platform.sh"

# Check we're in the right directory
check_dotfiles_dir

# Function to install common tools (e.g., zsh)
install_common() {
    print_info "Installing common tools and dotfiles..."
    chmod +x ./install_common.sh
    ./install_common.sh
}

# Function to handle macOS with Homebrew
install_macos() {
    print_info "Setting up macOS environment..."

    # Check if Homebrew is installed
    if ! command_exists brew; then
        print_error "Homebrew is not installed. Please install it first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    chmod +x ./macos/install_packages.sh
    ./macos/install_packages.sh
}

# Function to handle Ubuntu
install_ubuntu() {
    print_info "Setting up Ubuntu environment..."

    sudo apt update
    chmod +x ./ubuntu/install_packages.sh
    ./ubuntu/install_packages.sh
}

# Function to handle WSL
install_wsl() {
    print_info "Setting up WSL environment..."

    # WSL typically uses Ubuntu, so run Ubuntu setup
    sudo apt update
    chmod +x ./ubuntu/install_packages.sh
    ./ubuntu/install_packages.sh
}

# Main script
print_info "Dotfiles Installation Script"
echo "================================"
echo ""

# Auto-detect platform
DETECTED_PLATFORM=$(detect_platform)

if [ "$DETECTED_PLATFORM" = "unknown" ]; then
    print_error "Could not detect platform. Please run on macOS, Ubuntu, or WSL."
    exit 1
fi

print_success "Detected platform: $DETECTED_PLATFORM"
echo ""

# Ask for confirmation or manual override
read -p "Is this correct? (y/n) or enter platform manually (macos/ubuntu/wsl): " choice

case "$choice" in
    y|Y|yes|YES)
        PLATFORM=$DETECTED_PLATFORM
        ;;
    n|N|no|NO)
        read -p "Enter your platform (macos/ubuntu/wsl): " PLATFORM
        ;;
    macos|ubuntu|wsl)
        PLATFORM=$choice
        ;;
    *)
        print_error "Invalid choice. Exiting."
        exit 1
        ;;
esac

print_info "Installing for platform: $PLATFORM"
echo ""

# Run platform-specific installation
case "$PLATFORM" in
    macos)
        install_macos
        install_common
        ;;
    ubuntu)
        install_ubuntu
        install_common
        ;;
    wsl)
        install_wsl
        install_common
        ;;
    *)
        print_error "Invalid platform: $PLATFORM"
        exit 1
        ;;
esac

print_success "Setup completed successfully!"
print_info "Please restart your terminal or run: source ~/.zshrc"
