#!/bin/bash

# Dotfiles sync script
# This script syncs your dotfiles repository with the latest changes

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    print_error "Git is not installed. Please install git first."
    exit 1
fi

# Check if we're in a git repository
if ! git -C "$DOTFILES_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    print_error "Not a git repository. Please run this script from within your dotfiles repository."
    exit 1
fi

# Pull the latest changes
print_info "Pulling the latest changes from the remote repository..."
if git -C "$DOTFILES_DIR" pull; then
    print_success "Successfully pulled the latest changes."
else
    print_error "Failed to pull the latest changes. Please resolve any conflicts manually."
    exit 1
fi

# Run the installer to apply any new changes
print_info "Running the installer to apply any new changes..."
if "$DOTFILES_DIR/install.sh"; then
    print_success "Successfully applied the latest changes."
else
    print_error "Failed to apply the latest changes. Please check the error messages above."
    exit 1
fi

print_success "Dotfiles sync completed successfully!" 