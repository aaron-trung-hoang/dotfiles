#!/bin/bash

# Update VSCode settings from currently installed settings
# Run this script after modifying VSCode settings

set -e

# Source platform utilities
# shellcheck disable=SC1091
source "$(dirname "$0")/../lib/platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/.."

print_info "Updating VSCode settings from system..."

# Detect platform
PLATFORM=$(detect_platform)

if [ "$PLATFORM" = "macos" ]; then
    VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
elif [ "$PLATFORM" = "ubuntu" ] || [ "$PLATFORM" = "wsl" ]; then
    VSCODE_SETTINGS_DIR="$HOME/.config/Code/User"
else
    print_error "Unsupported platform: $PLATFORM"
    exit 1
fi

if [ ! -d "$VSCODE_SETTINGS_DIR" ]; then
    print_error "VSCode settings directory not found at: $VSCODE_SETTINGS_DIR"
    exit 1
fi

# Copy only when source and destination are not the same file.
copy_vscode_file() {
    local filename=$1
    local source_file="$VSCODE_SETTINGS_DIR/$filename"
    local target_file="$DOTFILES_DIR/vscode/$filename"

    if [ ! -f "$source_file" ]; then
        print_warning "$filename not found"
        return 0
    fi

    if [ -e "$target_file" ] && [ "$source_file" -ef "$target_file" ]; then
        print_info "$filename already points to dotfiles target; skipping copy"
        return 0
    fi

    print_info "Copying $filename..."
    cp "$source_file" "$target_file"
    print_success "$filename updated"
}

copy_vscode_file "settings.json"
copy_vscode_file "keybindings.json"

print_success "VSCode settings updated in dotfiles!"
print_info "Don't forget to commit the changes!"
