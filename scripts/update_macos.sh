#!/bin/bash

# Update macOS Brewfile with currently installed packages
# Run this script after installing new packages with brew

set -e

# Source platform utilities
source "$(dirname "$0")/../lib/platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$SCRIPT_DIR/../macos/Brewfile"

print_info "Updating macOS Brewfile..."

# Check if Homebrew is installed
if ! command_exists brew; then
    print_error "Homebrew is not installed!"
    exit 1
fi

# Backup existing Brewfile
if [ -f "$BREWFILE" ]; then
    backup_file "$BREWFILE"
fi

# Generate new Brewfile
print_info "Generating Brewfile from currently installed packages..."
brew bundle dump --file="$BREWFILE" --force

print_success "Brewfile updated at: $BREWFILE"
print_info "Don't forget to commit the changes!"
