#!/usr/bin/env bash

# Simple installation script (alternative to bootstrap.sh)
# Usage: ./install.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Installing dotfiles from $DOTFILES_DIR"

# Check if we're in the right directory
if [[ ! -f "$DOTFILES_DIR/justfile" ]]; then
    echo "❌ Error: justfile not found. Make sure you're running this from the dotfiles directory."
    exit 1
fi

# Check for required tools
REQUIRED_TOOLS=("stow" "just" "brew")
MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [[ ${#MISSING_TOOLS[@]} -gt 0 ]]; then
    echo "❌ Missing required tools: ${MISSING_TOOLS[*]}"
    echo "💡 Run the bootstrap script instead: curl -fsSL https://raw.githubusercontent.com/asifmomin/dotfiles/main/bootstrap.sh | bash"
    exit 1
fi

# Run the justfile bootstrap
echo "📦 Running dotfiles installation..."
just bootstrap

echo "✅ Installation completed!"
echo "🔄 Restart your shell or run: source ~/.zshrc"