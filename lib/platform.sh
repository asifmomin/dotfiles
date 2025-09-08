#!/usr/bin/env bash

# Platform detection utilities
# Usage: source lib/platform.sh

# Detect the current platform
detect_platform() {
    local platform
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        platform="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version 2>/dev/null; then
            platform="wsl"
        else
            platform="linux"
        fi
    else
        platform="unknown"
    fi
    
    echo "$platform"
}

# Check if running on macOS
is_macos() {
    [[ $(detect_platform) == "macos" ]]
}

# Check if running on Linux
is_linux() {
    [[ $(detect_platform) == "linux" ]]
}

# Check if running on WSL
is_wsl() {
    [[ $(detect_platform) == "wsl" ]]
}

# Check if running on Unix-like system (macOS or Linux)
is_unix() {
    [[ $(detect_platform) =~ ^(macos|linux|wsl)$ ]]
}

# Get Homebrew prefix based on platform
get_brew_prefix() {
    if is_macos; then
        echo "/opt/homebrew"
    else
        echo "/home/linuxbrew/.linuxbrew"
    fi
}

# Get shell config path
get_shell_config() {
    echo "$HOME/.zshrc"
}

# Export functions if this file is sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    export -f detect_platform is_macos is_linux is_wsl is_unix get_brew_prefix get_shell_config
fi