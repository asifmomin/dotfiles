#!/usr/bin/env bash

set -euo pipefail

echo "🗑️  Removing stow packages..."

cd packages
removed=0

for package in */; do
    if [[ -d "$package" ]]; then
        name=${package%/}
        echo "Removing package: $name"
        if stow -d . -t ~ -D "$name"; then
            echo "  ✓ $name removed successfully"
            removed=$((removed + 1))
        else
            echo "  ✗ $name failed to remove"
        fi
    fi
done

echo ""
echo "✓ Removed $removed packages"