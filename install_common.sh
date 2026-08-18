#!/bin/bash

set -e  # Exit on error

# Source platform utilities
source "$(dirname "$0")/lib/platform.sh"

print_info "Installing common tools and configurations..."
echo ""

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "oh-my-zsh installed"
else
    print_info "oh-my-zsh is already installed"
fi

# Install zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_success "zsh-autosuggestions installed"
else
    print_info "zsh-autosuggestions is already installed"
fi

# Install powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    print_info "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    print_success "powerlevel10k installed"
else
    print_info "powerlevel10k is already installed"
fi

# Install zsh-autocomplete
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]; then
    print_info "Installing zsh-autocomplete..."
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete"
    print_success "zsh-autocomplete installed"
else
    print_info "zsh-autocomplete is already installed"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    print_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_success "zsh-syntax-highlighting installed"
else
    print_info "zsh-syntax-highlighting is already installed"
fi

echo ""
print_info "Managing dotfiles with GNU Stow..."
echo ""

# Check if stow is installed
if ! command_exists stow; then
    print_error "GNU Stow is not installed. Please install it first:"
    echo "  macOS: brew install stow"
    echo "  Ubuntu: sudo apt install stow"
    exit 1
fi

# Dotfiles to manage
dotfiles=(.zshrc .zshenv .p10k.zsh .tmux.conf .gitconfig)

# Clean up existing files and create symbolic links
for file in "${dotfiles[@]}"; do
    if [ -L "$HOME/$file" ]; then
        print_info "$file is already a symlink. Removing it."
        rm -f -- "${HOME:?}/$file"
    elif [ -f "$HOME/$file" ]; then
        backup_file "$HOME/$file"
    else
        print_info "$file not found, will be created."
    fi
done

echo ""
print_info "Applying stow for dotfiles..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Apply stow for each configuration directory
for config_dir in zsh tmux git codex nvim ghostty; do
    if [ -d "$DOTFILES_DIR/$config_dir" ]; then
        if [ "$config_dir" = "codex" ]; then
            prepare_stow_file \
                "$DOTFILES_DIR/codex/.codex/AGENTS.md" \
                "$HOME/.codex/AGENTS.md"
        elif [ "$config_dir" = "nvim" ] || [ "$config_dir" = "ghostty" ]; then
            mkdir -p "$HOME/.config"
        fi

        print_info "Stowing $config_dir..."
        if stow_output=$(stow -v -d "$DOTFILES_DIR" -t ~ "$config_dir" 2>&1); then
            echo "$stow_output" | grep -v "^LINK: " || true
            print_success "$config_dir stowed successfully"
        else
            echo "$stow_output"
            print_error "Failed to stow $config_dir"
            exit 1
        fi
    else
        print_warning "Directory $config_dir not found, skipping..."
    fi
done

echo ""
print_info "Setting up additional configurations..."

# Copy the terminal background image
if [ -f "$DOTFILES_DIR/background/terminal.jpg" ]; then
    print_info "Setting up terminal background..."
    mkdir -p "$HOME/.background-terminal"
    cp "$DOTFILES_DIR/background/terminal.jpg" "$HOME/.background-terminal/"
    print_success "Terminal background configured"
else
    print_warning "Background image not found, skipping..."
fi

# Setup VSCode configuration symlinks
print_info "Setting up VSCode configuration..."

# Determine VSCode config path based on platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
else
    VSCODE_CONFIG_DIR=""
fi

if [ -n "$VSCODE_CONFIG_DIR" ] && [ -d "$DOTFILES_DIR/vscode" ]; then
    # Create VSCode config directory if it doesn't exist
    mkdir -p "$VSCODE_CONFIG_DIR"

    # Symlink settings.json
    if [ -f "$DOTFILES_DIR/vscode/settings.json" ]; then
        if [ -L "$VSCODE_CONFIG_DIR/settings.json" ]; then
            print_info "VSCode settings.json is already a symlink. Removing it."
            rm -f "$VSCODE_CONFIG_DIR/settings.json"
        elif [ -f "$VSCODE_CONFIG_DIR/settings.json" ]; then
            backup_file "$VSCODE_CONFIG_DIR/settings.json"
        fi
        ln -s "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
        print_success "VSCode settings.json symlinked"
    fi

    # Symlink keybindings.json
    if [ -f "$DOTFILES_DIR/vscode/keybindings.json" ]; then
        if [ -L "$VSCODE_CONFIG_DIR/keybindings.json" ]; then
            print_info "VSCode keybindings.json is already a symlink. Removing it."
            rm -f "$VSCODE_CONFIG_DIR/keybindings.json"
        elif [ -f "$VSCODE_CONFIG_DIR/keybindings.json" ]; then
            backup_file "$VSCODE_CONFIG_DIR/keybindings.json"
        fi
        ln -s "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"
        print_success "VSCode keybindings.json symlinked"
    fi
else
    print_warning "VSCode config directory not found or unsupported platform, skipping..."
fi

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    print_info "Setting zsh as default shell..."
    if command_exists chsh; then
        chsh -s "$(which zsh)"
        print_success "Default shell changed to zsh"
        print_warning "You may need to log out and back in for this to take effect"
    else
        print_warning "Could not change default shell automatically. Please run: chsh -s \$(which zsh)"
    fi
else
    print_info "zsh is already the default shell"
fi

echo ""
print_success "Common tools installation completed!"
