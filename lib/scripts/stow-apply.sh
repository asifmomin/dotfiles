#!/usr/bin/env bash

set -euo pipefail

echo "🔗 Applying stow packages..."

cd packages
applied=0
failed=0

for package in */; do
    if [[ -d "$package" ]]; then
        name=${package%/}
        echo "Applying package: $name"
        if output=$(stow -d . -t ~ "$name" 2>&1); then
            echo "  ✓ $name applied successfully"
            applied=$((applied + 1))
        else
            echo "  ✗ $name failed to apply"
            echo "$output" | sed 's/^/    /'
            failed=$((failed + 1))
        fi
    fi
done

echo ""
echo "✓ Applied $applied packages"
if [[ $failed -gt 0 ]]; then
    echo "⚠ $failed packages failed to apply"
fi

if [[ -f ~/.zshrc ]]; then
    echo "💡 Restart your shell to load new configuration"
fi