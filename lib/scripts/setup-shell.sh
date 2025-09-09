#!/usr/bin/env bash

set -euo pipefail

echo "🐚 Setting up shell configuration..."

# Check if Homebrew zsh exists
HOMEBREW_ZSH="/home/linuxbrew/.linuxbrew/bin/zsh"
SYSTEM_ZSH="/usr/bin/zsh"

if [[ -x "$HOMEBREW_ZSH" ]]; then
    TARGET_ZSH="$HOMEBREW_ZSH"
    echo "Found Homebrew zsh: $HOMEBREW_ZSH"
elif [[ -x "$SYSTEM_ZSH" ]]; then
    TARGET_ZSH="$SYSTEM_ZSH"
    echo "Found system zsh: $SYSTEM_ZSH"
else
    echo "❌ No zsh installation found"
    exit 1
fi

# Check if already in /etc/shells
if grep -q "^$TARGET_ZSH$" /etc/shells 2>/dev/null; then
    echo "✓ $TARGET_ZSH already registered in /etc/shells"
else
    echo "Adding $TARGET_ZSH to /etc/shells..."
    if sudo -n true 2>/dev/null; then
        echo "$TARGET_ZSH" | sudo tee -a /etc/shells > /dev/null
        echo "✓ Added $TARGET_ZSH to /etc/shells"
    else
        echo "⚠ Need sudo access to add $TARGET_ZSH to /etc/shells"
        echo "Please run: echo '$TARGET_ZSH' | sudo tee -a /etc/shells"
        echo "Then run: chsh -s $TARGET_ZSH"
        exit 0
    fi
fi

# Check current shell
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ "$CURRENT_SHELL" == "$TARGET_ZSH" ]]; then
    echo "✓ $TARGET_ZSH is already the default shell"
else
    echo "Setting $TARGET_ZSH as default shell..."
    if chsh -s "$TARGET_ZSH"; then
        echo "✓ Default shell changed to $TARGET_ZSH"
        echo "💡 Restart your terminal or run 'exec $TARGET_ZSH' to use the new shell"
    else
        echo "⚠ Failed to change default shell"
        echo "Please run manually: chsh -s $TARGET_ZSH"
    fi
fi