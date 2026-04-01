#!/bin/bash

set -e  # Exit on error

# Source platform utilities
# shellcheck disable=SC1091
source "$(dirname "$0")/../lib/platform.sh"

print_info "Installing Ubuntu packages..."
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APT_PACKAGES_FILE="$SCRIPT_DIR/apt_packages"
SNAP_APPS_FILE="$SCRIPT_DIR/snap_apps"

# Update package list
print_info "Updating package list..."
sudo apt update

# Install apt packages
if [ -f "$APT_PACKAGES_FILE" ]; then
    print_info "Installing apt packages..."

    # Read packages into an array, skipping empty/comment lines.
    packages=()
    while IFS= read -r package; do
        if [ -n "$package" ] && [[ ! "$package" =~ ^# ]]; then
            packages+=("$package")
        fi
    done < "$APT_PACKAGES_FILE"

    if [ "${#packages[@]}" -gt 0 ]; then
        echo "Packages to install: ${packages[*]}"
        echo ""
        sudo apt install -y "${packages[@]}"
        print_success "apt packages installed"
    else
        print_warning "No apt packages to install"
    fi
else
    print_warning "apt_packages file not found at $APT_PACKAGES_FILE"
fi

echo ""

# Install snap apps
if [ -f "$SNAP_APPS_FILE" ]; then
    print_info "Installing snap applications..."

    # Check if snap is installed
    if ! command_exists snap; then
        print_error "snapd is not installed. Installing..."
        sudo apt install -y snapd
    fi

    # Read and install snap apps
    while IFS=: read -r app_name app_classic || [ -n "$app_name" ]; do
        # Skip empty lines and comments
        if [ -z "$app_name" ] || [[ "$app_name" =~ ^#.* ]]; then
            continue
        fi

        print_info "Installing snap: $app_name..."

        if [ "$app_classic" == "classic" ]; then
            sudo snap install "$app_name" --classic
        else
            sudo snap install "$app_name"
        fi

        print_success "$app_name installed"
    done < "$SNAP_APPS_FILE"

    print_success "snap applications installed"
else
    print_warning "snap_apps file not found at $SNAP_APPS_FILE"
fi

echo ""

# Upgrade packages
print_info "Upgrading packages..."
sudo apt upgrade -y

print_success "Ubuntu packages installation completed!"
