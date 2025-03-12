#!/bin/bash

# Cross-platform dotfiles installer
# Detects OS and runs appropriate bootstrapping script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"
PLATFORM_DIR="$DOTFILES_DIR/platform"
BOOTSTRAP_DIR="$DOTFILES_DIR/bootstrap"

# Print with color
print_info() {
    printf "\e[0;34m%s\e[0m\n" "$1"
}

print_success() {
    printf "\e[0;32m%s\e[0m\n" "$1"
}

print_error() {
    printf "\e[0;31m%s\e[0m\n" "$1"
}

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            echo "linux"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "windows"
            ;;
        *)
            print_error "Unsupported operating system"
            exit 1
            ;;
    esac
}

# Create symbolic links for common configs
link_common_configs() {
    print_info "Setting up common configurations..."
    
    # Link git config
    if [ -f "$CONFIG_DIR/git/gitconfig" ]; then
        ln -sf "$CONFIG_DIR/git/gitconfig" "$HOME/.gitconfig"
        print_success "Linked gitconfig"
    fi
    
    # Link shell aliases
    if [ -f "$CONFIG_DIR/shell/aliases" ]; then
        ln -sf "$CONFIG_DIR/shell/aliases" "$HOME/.aliases"
        print_success "Linked aliases"
    fi
    
    # Link common shell settings
    if [ -f "$CONFIG_DIR/shell/shellrc" ]; then
        ln -sf "$CONFIG_DIR/shell/shellrc" "$HOME/.shellrc"
        print_success "Linked shellrc"
    fi
}

# Main installation process
main() {
    print_info "Starting dotfiles installation..."
    
    # Detect OS
    OS=$(detect_os)
    print_info "Detected operating system: $OS"
    
    # Link common configs
    link_common_configs
    
    # Run OS-specific bootstrap
    case "$OS" in
        macos)
            if [ -f "$BOOTSTRAP_DIR/install_mac.sh" ]; then
                print_info "Running macOS bootstrapping..."
                bash "$BOOTSTRAP_DIR/install_mac.sh"
            else
                print_error "macOS bootstrap script not found"
            fi
            ;;
        linux)
            if [ -f "$BOOTSTRAP_DIR/install_linux.sh" ]; then
                print_info "Running Linux bootstrapping..."
                bash "$BOOTSTRAP_DIR/install_linux.sh"
            else
                print_error "Linux bootstrap script not found"
            fi
            ;;
        windows)
            if [ -f "$BOOTSTRAP_DIR/install_windows.ps1" ]; then
                print_info "Running Windows bootstrapping..."
                powershell -ExecutionPolicy Bypass -File "$BOOTSTRAP_DIR/install_windows.ps1"
            else
                print_error "Windows bootstrap script not found"
            fi
            ;;
    esac
    
    print_success "Dotfiles installation complete!"
}

# Run the installer
main 