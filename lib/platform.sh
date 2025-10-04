#!/bin/bash

# Platform detection and utilities

# Detect the current platform
detect_platform() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "ubuntu"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Print colored output
print_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

print_warning() {
    echo -e "\033[0;33m[WARNING]\033[0m $1"
}

# Check if script is run from dotfiles directory
check_dotfiles_dir() {
    if [ ! -f "main.sh" ] || [ ! -d "zsh" ]; then
        print_error "This script must be run from the dotfiles directory"
        exit 1
    fi
}

# Backup existing file
backup_file() {
    local file=$1
    if [ -f "$file" ] && [ ! -L "$file" ]; then
        print_warning "$file already exists. Creating backup..."
        mv "$file" "${file}.bak.$(date +%Y%m%d_%H%M%S)"
        print_success "Backup created: ${file}.bak.$(date +%Y%m%d_%H%M%S)"
    fi
}

# Export functions
export -f detect_platform
export -f command_exists
export -f print_info
export -f print_success
export -f print_error
export -f print_warning
export -f check_dotfiles_dir
export -f backup_file
