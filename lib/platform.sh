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
        local timestamp
        local backup_path
        timestamp="$(date +%Y%m%d_%H%M%S)"
        backup_path="${file}.bak.${timestamp}"
        print_warning "$file already exists. Creating backup..."
        mv "$file" "$backup_path"
        print_success "Backup created: $backup_path"
    fi
}

# Preserve foreign symlinks and back up regular files before Stow takes ownership
prepare_stow_file() {
    local source_file=$1
    local target_file=$2

    mkdir -p "$(dirname "$target_file")"

    if [ -L "$target_file" ]; then
        if [ "$target_file" -ef "$source_file" ]; then
            print_info "$target_file is already linked to this dotfiles repository"
            return 0
        fi

        print_error "$target_file is a symlink managed outside this dotfiles repository"
        print_error "Preserving it. Remove it manually if you want Stow to replace it."
        return 1
    fi

    if [ -f "$target_file" ]; then
        backup_file "$target_file"
    elif [ -e "$target_file" ]; then
        print_error "$target_file exists and is not a regular file"
        return 1
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
export -f prepare_stow_file
