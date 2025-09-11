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
        # Linux/WSL - Install to user's home directory (no sudo required)
        print_step "Installing Homebrew to user directory (no sudo required)"
        
        # Set Homebrew to install in user's home directory
        export HOMEBREW_PREFIX="$HOME/.linuxbrew"
        
        # Install Homebrew without sudo
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Linux/WSL
        if [[ -d "$HOME/.linuxbrew" ]]; then
            echo 'eval "$($HOME/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
            eval "$($HOME/.linuxbrew/bin/brew shellenv)"
        elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
            # Fallback if it still installed to system location
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi
    
    print_success "Homebrew installed"
}

# Ensure Homebrew is in PATH
ensure_brew_in_path() {
    if [[ -d "$HOME/.linuxbrew" ]]; then
        eval "$($HOME/.linuxbrew/bin/brew shellenv)"
    elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

# Install system dependencies
install_system_deps() {
    local platform
    platform=$(detect_platform)
    
    if [[ "$platform" == "linux" ]] || [[ "$platform" == "wsl" ]]; then
        print_step "Installing system build dependencies"
        
        if command_exists apt-get; then
            print_step "Installing build-essential via apt"
            # Use -n flag to avoid prompting if sudo session is still active
            sudo -n true 2>/dev/null || sudo -v
            sudo apt-get update -qq
            sudo apt-get install -y -qq build-essential || {
                print_warning "Failed to install build-essential, continuing..."
            }
            print_success "System dependencies installed"
        else
            print_warning "apt-get not found, skipping system dependencies"
        fi
    fi
}

# Install essential tools
install_essentials() {
    print_step "Installing essential tools"
    
    # Ensure brew is in PATH
    ensure_brew_in_path
    
    # Verify brew is available
    if ! command_exists brew; then
        print_error "Homebrew not found in PATH after installation"
        print_warning "Please manually add Homebrew to your PATH and run the script again"
        exit 1
    fi
    
    # Install core tools needed for dotfiles
    print_step "Installing stow, just, sops, age, git..."
    brew install --quiet stow just sops age git || {
        print_warning "Some packages may have failed to install, continuing..."
    }
    
    # Verify critical tools
    if ! command_exists just; then
        print_warning "'just' command not found, attempting to install again..."
        brew install just
    fi
    
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
    
    # Ensure brew is in PATH before running just
    ensure_brew_in_path
    
    # Verify just command is available
    if ! command_exists just; then
        print_error "'just' command not found. Please ensure it's installed and in PATH"
        print_warning "Try running: brew install just"
        exit 1
    fi
    
    print_step "Running: just bootstrap"
    # Run the bootstrap command which installs packages AND applies stow
    if just bootstrap; then
        print_success "Successfully ran 'just bootstrap'"
    else
        print_warning "Bootstrap may have partially failed"
        print_step "Attempting to apply stow configurations manually..."
        just stow-apply || print_warning "Stow apply failed - you may need to run it manually"
    fi
    
    print_success "Dotfiles bootstrap completed"
    
    # Verify critical symlinks were created
    if [[ ! -f "$HOME/.zshrc" ]]; then
        print_warning ".zshrc not found - stow may not have applied correctly"
        print_warning "Run 'cd $DOTFILES_DIR && just stow-apply' to fix this"
    fi
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

# Check sudo access for Linux/WSL (optional, only for system packages)
check_sudo_access() {
    local platform
    platform=$(detect_platform)
    
    if [[ "$platform" == "linux" ]] || [[ "$platform" == "wsl" ]]; then
        if ! command_exists sudo; then
            print_warning "sudo not available - skipping system package installation"
            print_warning "You may need to install build-essential manually if needed"
            return 1
        fi
        
        print_step "Checking sudo access for optional system packages"
        if ! sudo -v; then
            print_warning "Unable to obtain sudo access - continuing without system packages"
            print_warning "You may need to install build-essential manually if needed"
            return 1
        fi
        
        # Keep sudo alive for the duration of the script
        # This runs in background and touches sudo every 50 seconds
        ( while true; do sudo -v; sleep 50; done ) &
        SUDO_KEEPALIVE_PID=$!
    fi
    
    return 0
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
    
    # Ensure Homebrew is in PATH for the rest of the script
    ensure_brew_in_path
    
    # Check sudo access for optional system packages (don't exit if unavailable)
    local has_sudo=false
    if check_sudo_access; then
        has_sudo=true
    fi
    
    # Install system dependencies only if sudo is available
    if [[ "$has_sudo" == true ]]; then
        install_system_deps
    else
        print_warning "Skipping system package installation (no sudo access)"
        print_info "Homebrew will install most required dependencies"
    fi
    
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
    
    # Kill the sudo keepalive process if it exists
    if [[ -n "${SUDO_KEEPALIVE_PID:-}" ]]; then
        kill $SUDO_KEEPALIVE_PID 2>/dev/null || true
    fi
}

# Handle script interruption
trap 'echo -e "\n${RED}Bootstrap interrupted${NC}"; exit 130' INT

# Check if script is being sourced or executed
# When piped to bash, BASH_SOURCE might not be set, so we always run main
if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]] || [[ -z "${BASH_SOURCE[0]:-}" ]]; then
    main "$@"
fi