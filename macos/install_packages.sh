#!/bin/bash

set -e  # Exit on error

# Source platform utilities
source "$(dirname "$0")/../lib/platform.sh"

print_info "Installing macOS packages via Homebrew..."
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$SCRIPT_DIR/Brewfile"

if [ ! -f "$BREWFILE" ]; then
    print_error "Brewfile not found at $BREWFILE"
    exit 1
fi

# Check if Homebrew is installed
if ! command_exists brew; then
    print_error "Homebrew is not installed!"
    exit 1
fi

# Update Homebrew
print_info "Updating Homebrew..."
brew update

# Backup existing Brewfile if it exists in home
if [ -f ~/Brewfile ]; then
    print_warning "Backing up existing ~/Brewfile"
    backup_file ~/Brewfile
fi

# Install from Brewfile
print_info "Installing packages from Brewfile..."
print_info "This may take a while..."
echo ""

brew bundle --file="$BREWFILE"

echo ""
print_success "macOS packages installation completed!"
print_info "Installed packages:"
brew bundle list --file="$BREWFILE" | head -20
