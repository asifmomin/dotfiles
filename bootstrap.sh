#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Dotfiles configuration
DOTFILES_REPO="https://github.com/asifmomin/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Print functions
print_step() {
    echo -e "${BLUE}==>${NC} ${CYAN}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Dotfiles Bootstrap                        ║"
    echo "║            Stow + just + sops/age + Tokyo Night             ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version 2>/dev/null; then
            echo "wsl"
        else
            echo "linux"
        fi
    else
        echo "unknown"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew
install_homebrew() {
    if command_exists brew; then
        print_success "Homebrew already installed"
        return
    fi

    print_step "Installing Homebrew"
    if [[ $(detect_platform) == "macos" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        # Linux/WSL
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Linux/WSL
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    
    print_success "Homebrew installed"
}

# Install essential tools
install_essentials() {
    print_step "Installing essential tools"
    
    # Install core tools needed for dotfiles
    brew install --quiet stow just sops age git
    
    print_success "Essential tools installed"
}

# Clone dotfiles repository
clone_dotfiles() {
    print_step "Cloning dotfiles repository"
    
    if [[ -d "$DOTFILES_DIR" ]]; then
        print_warning "Dotfiles directory exists, pulling latest changes"
        cd "$DOTFILES_DIR"
        git pull --quiet origin main || git pull --quiet origin master
    else
        git clone --quiet "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
    
    cd "$DOTFILES_DIR"
    print_success "Dotfiles repository ready"
}

# Run justfile bootstrap
run_bootstrap() {
    print_step "Running dotfiles bootstrap"
    
    cd "$DOTFILES_DIR"
    
    # Check if justfile exists
    if [[ ! -f "justfile" ]]; then
        print_error "justfile not found in dotfiles repository"
        exit 1
    fi
    
    # Run the bootstrap command
    just bootstrap
    
    print_success "Dotfiles bootstrap completed"
}

# Backup existing configs
backup_configs() {
    print_step "Backing up existing configurations"
    
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    local backed_up=false
    
    # List of common config files/dirs to backup
    local configs=(
        ".zshrc" ".bashrc" ".gitconfig" ".tmux.conf"
        ".config/alacritty" ".config/nvim" ".config/starship.toml"
        ".config/git" ".config/tmux" ".config/zsh"
    )
    
    for config in "${configs[@]}"; do
        if [[ -e "$HOME/$config" ]]; then
            if [[ ! -d "$backup_dir" ]]; then
                mkdir -p "$backup_dir"
            fi
            cp -r "$HOME/$config" "$backup_dir/"
            backed_up=true
        fi
    done
    
    if [[ "$backed_up" == true ]]; then
        print_success "Existing configs backed up to: $backup_dir"
    else
        print_success "No existing configs found to backup"
    fi
}

# Main execution
main() {
    print_header
    
    local platform
    platform=$(detect_platform)
    
    print_step "Detected platform: $platform"
    
    # Check for required commands
    if ! command_exists curl; then
        print_error "curl is required but not installed"
        exit 1
    fi
    
    if ! command_exists git; then
        print_error "git is required but not installed"
        exit 1
    fi
    
    # Run installation steps
    backup_configs
    install_homebrew
    install_essentials
    clone_dotfiles
    run_bootstrap
    
    echo
    print_success "🎉 Dotfiles bootstrap completed successfully!"
    echo
    echo -e "${CYAN}Next steps:${NC}"
    echo "  1. Restart your shell or run: source ~/.zshrc"
    echo "  2. Run 'just doctor' to verify installation"
    echo "  3. Run 'just secrets:init' to setup encrypted secrets"
    echo
    echo -e "${YELLOW}Available commands:${NC}"
    echo "  just doctor          # Health check"
    echo "  just stow-check      # Preview changes"
    echo "  just stow-apply      # Apply configs"
    echo "  just secrets:init    # Setup secrets"
    echo "  just update          # Update everything"
    echo
}

# Handle script interruption
trap 'echo -e "\n${RED}Bootstrap interrupted${NC}"; exit 130' INT

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi