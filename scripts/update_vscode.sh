#!/bin/bash

# Update VSCode settings from currently installed settings
# Run this script after modifying VSCode settings

set -e

# Source platform utilities
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

# Copy settings.json
if [ -f "$VSCODE_SETTINGS_DIR/settings.json" ]; then
    print_info "Copying settings.json..."
    cp "$VSCODE_SETTINGS_DIR/settings.json" "$DOTFILES_DIR/vscode/settings.json"
    print_success "settings.json updated"
else
    print_warning "settings.json not found"
fi

# Copy keybindings.json
if [ -f "$VSCODE_SETTINGS_DIR/keybindings.json" ]; then
    print_info "Copying keybindings.json..."
    cp "$VSCODE_SETTINGS_DIR/keybindings.json" "$DOTFILES_DIR/vscode/keybindings.json"
    print_success "keybindings.json updated"
else
    print_warning "keybindings.json not found"
fi

print_success "VSCode settings updated in dotfiles!"
print_info "Don't forget to commit the changes!"
