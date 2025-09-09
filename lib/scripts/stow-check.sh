#!/usr/bin/env bash

set -euo pipefail

echo "🔍 Checking stow operations (dry run)..."
echo ""

cd packages

for package in */; do
    if [[ -d "$package" ]]; then
        name=${package%/}
        echo "Package: $name"
        stow -d . -t ~ -n -v "$name" 2>&1 | sed 's/^/  /' || echo "  ⚠ No operations for $name"
        echo ""
    fi
done