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

# Print usage information
print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --all         Install everything (default if no options provided)"
    echo "  --git        Install git configuration only"
    echo "  --aliases    Install shell aliases only"
    echo "  --shell      Install shell configuration only"
    echo "  --help       Show this help message"
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
        *)
            print_error "Unsupported operating system"
            exit 1
            ;;
    esac
}

# Create symbolic links for common configs
link_common_configs() {
    local install_git=0
    local install_aliases=0
    local install_shell=0
    
    # Parse arguments
    if [ $# -eq 0 ] || [ "$1" == "--all" ]; then
        install_git=1
        install_aliases=1
        install_shell=1
    else
        for arg in "$@"; do
            case "$arg" in
                --git)
                    install_git=1
                    ;;
                --aliases)
                    install_aliases=1
                    ;;
                --shell)
                    install_shell=1
                    ;;
            esac
        done
    fi
    
    print_info "Setting up selected configurations..."
    
    # Link git config
    if [ $install_git -eq 1 ] && [ -f "$CONFIG_DIR/git/gitconfig" ]; then
        ln -sf "$CONFIG_DIR/git/gitconfig" "$HOME/.gitconfig"
        print_success "Linked gitconfig"
    fi
    
    # Link shell aliases
    if [ $install_aliases -eq 1 ] && [ -f "$CONFIG_DIR/shell/aliases" ]; then
        ln -sf "$CONFIG_DIR/shell/aliases" "$HOME/.aliases"
        print_success "Linked aliases"
    fi
    
    # Link common shell settings
    if [ $install_shell -eq 1 ] && [ -f "$CONFIG_DIR/shell/shellrc" ]; then
        ln -sf "$CONFIG_DIR/shell/shellrc" "$HOME/.shellrc"
        print_success "Linked shellrc"
    fi
}

# Main installation process
main() {
    # Check for help flag
    if [[ "$1" == "--help" ]]; then
        print_usage
        exit 0
    fi
    
    print_info "Starting dotfiles installation..."
    
    # Detect OS
    OS=$(detect_os)
    print_info "Detected operating system: $OS"
    
    # Link configs with arguments
    link_common_configs "$@"
    
    # Only run OS-specific bootstrap if no specific options were provided
    if [ $# -eq 0 ] || [ "$1" == "--all" ]; then
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
        esac
    fi
    
    print_success "Dotfiles installation complete!"
}

# Run the installer with all arguments
main "$@" 