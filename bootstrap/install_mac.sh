#!/bin/bash

# macOS-specific bootstrapping script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLATFORM_DIR="$DOTFILES_DIR/platform/macos"

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

# Install Homebrew if not already installed
install_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_success "Homebrew installed successfully"
    else
        print_info "Homebrew already installed"
    fi
}

# Install packages from Brewfile
install_packages() {
    if command -v brew >/dev/null 2>&1; then
        print_info "Installing packages with Homebrew..."
        
        if [ -f "$PLATFORM_DIR/brewfile" ]; then
            brew update
            brew bundle --file="$PLATFORM_DIR/brewfile"
            print_success "Packages installed successfully"
        else
            print_error "Brewfile not found"
        fi
    else
        print_error "Homebrew not found, skipping package installation"
    fi
}

# Link macOS-specific dotfiles
link_dotfiles() {
    print_info "Linking macOS-specific dotfiles..."
    
    # Link zshrc
    if [ -f "$PLATFORM_DIR/zshrc" ]; then
        # Backup existing zshrc if it's not a symlink
        if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
            mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
            print_info "Backed up existing .zshrc to .zshrc.backup"
        fi
        
        ln -sf "$PLATFORM_DIR/zshrc" "$HOME/.zshrc"
        print_success "Linked zshrc"
    fi
    
    # Source shellrc and aliases in zshrc if they're not already included
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "source.*\.shellrc" "$HOME/.zshrc"; then
            echo '[ -f "$HOME/.shellrc" ] && source "$HOME/.shellrc"' >> "$HOME/.zshrc"
            print_success "Added shellrc sourcing to zshrc"
        fi
        
        if ! grep -q "source.*\.aliases" "$HOME/.zshrc"; then
            echo '[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"' >> "$HOME/.zshrc"
            print_success "Added aliases sourcing to zshrc"
        fi
    fi
}

# Set macOS defaults
set_macos_defaults() {
    print_info "Setting macOS defaults..."
    
    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    
    # Show path bar in Finder
    defaults write com.apple.finder ShowPathbar -bool true
    
    # Show status bar in Finder
    defaults write com.apple.finder ShowStatusBar -bool true
    
    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    
    # Set a faster key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    
    # Restart affected applications
    for app in "Finder" "Dock" "SystemUIServer"; do
        killall "${app}" &> /dev/null
    done
    
    print_success "macOS defaults set successfully"
}

# Main function
main() {
    print_info "Starting macOS bootstrapping..."
    
    # Install Homebrew
    install_homebrew
    
    # Install packages
    install_packages
    
    # Link dotfiles
    link_dotfiles
    
    # Set macOS defaults
    set_macos_defaults
    
    print_success "macOS bootstrapping complete!"
}

# Run the script
main 