#!/usr/bin/env bash

set -euo pipefail

echo "🐚 Setting up shell configuration..."

# Check if Homebrew zsh exists (check user directory first)
USER_HOMEBREW_ZSH="$HOME/.linuxbrew/bin/zsh"
SYSTEM_HOMEBREW_ZSH="/home/linuxbrew/.linuxbrew/bin/zsh"
SYSTEM_ZSH="/usr/bin/zsh"

if [[ -x "$USER_HOMEBREW_ZSH" ]]; then
    TARGET_ZSH="$USER_HOMEBREW_ZSH"
    echo "Found Homebrew zsh (user): $USER_HOMEBREW_ZSH"
elif [[ -x "$SYSTEM_HOMEBREW_ZSH" ]]; then
    TARGET_ZSH="$SYSTEM_HOMEBREW_ZSH"
    echo "Found Homebrew zsh (system): $SYSTEM_HOMEBREW_ZSH"
elif [[ -x "$SYSTEM_ZSH" ]]; then
    TARGET_ZSH="$SYSTEM_ZSH"
    echo "Found system zsh: $SYSTEM_ZSH"
else
    echo "❌ No zsh installation found"
    echo "Please install zsh first: brew install zsh"
    exit 1
fi

# Check if already in /etc/shells
if grep -q "^$TARGET_ZSH$" /etc/shells 2>/dev/null; then
    echo "✓ $TARGET_ZSH is registered in /etc/shells"
else
    echo ""
    echo "📋 Manual setup required:"
    echo "   The shell '$TARGET_ZSH' needs to be added to /etc/shells"
    echo ""
    echo "   Please run this command:"
    echo "   echo '$TARGET_ZSH' | sudo tee -a /etc/shells"
    echo ""
    echo "   This registers the shell as a valid login shell."
    echo "   After running this command, re-run: just setup-shell"
    echo ""
    exit 0
fi

# Check current shell
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ "$CURRENT_SHELL" == "$TARGET_ZSH" ]]; then
    echo "✓ $TARGET_ZSH is already your default shell"
    echo "💡 Restart your terminal to ensure all configuration is loaded"
else
    echo "Setting $TARGET_ZSH as default shell..."
    if chsh -s "$TARGET_ZSH"; then
        echo "✓ Default shell changed to $TARGET_ZSH"
        echo ""
        echo "🎉 Shell setup complete!"
        echo "   Restart your terminal or run: exec $TARGET_ZSH"
    else
        echo "⚠ Failed to change default shell"
        echo "  This might happen if the shell isn't in /etc/shells yet."
        echo ""
        echo "  Please try manually:"
        echo "  chsh -s $TARGET_ZSH"
        echo ""
        echo "  If that fails, ensure /etc/shells contains: $TARGET_ZSH"
    fi
fi