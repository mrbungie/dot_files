#!/bin/bash

# Linux-specific bootstrapping script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLATFORM_DIR="$DOTFILES_DIR/platform/linux"

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

# Install packages if apt is available
install_packages() {
    if command -v apt-get >/dev/null 2>&1; then
        print_info "Installing packages with apt..."
        
        if [ -f "$PLATFORM_DIR/apt_packages" ]; then
            sudo apt-get update
            xargs -a "$PLATFORM_DIR/apt_packages" sudo apt-get install -y
            print_success "Packages installed successfully"
        else
            print_error "apt_packages file not found"
        fi
    else
        print_info "apt not found, skipping package installation"
    fi
}

# Link Linux-specific dotfiles
link_dotfiles() {
    print_info "Linking Linux-specific dotfiles..."
    
    # Link bashrc
    if [ -f "$PLATFORM_DIR/bashrc" ]; then
        # Backup existing bashrc if it's not a symlink
        if [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
            mv "$HOME/.bashrc" "$HOME/.bashrc.backup"
            print_info "Backed up existing .bashrc to .bashrc.backup"
        fi
        
        ln -sf "$PLATFORM_DIR/bashrc" "$HOME/.bashrc"
        print_success "Linked bashrc"
    fi
    
    # Source shellrc and aliases in bashrc if they're not already included
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "source.*\.shellrc" "$HOME/.bashrc"; then
            echo '[ -f "$HOME/.shellrc" ] && source "$HOME/.shellrc"' >> "$HOME/.bashrc"
            print_success "Added shellrc sourcing to bashrc"
        fi
        
        if ! grep -q "source.*\.aliases" "$HOME/.bashrc"; then
            echo '[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"' >> "$HOME/.bashrc"
            print_success "Added aliases sourcing to bashrc"
        fi
    fi
}

# Main function
main() {
    print_info "Starting Linux bootstrapping..."
    
    # Install packages
    install_packages
    
    # Link dotfiles
    link_dotfiles
    
    print_success "Linux bootstrapping complete!"
}

# Run the script
main 