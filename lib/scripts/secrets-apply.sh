#!/usr/bin/env bash

set -euo pipefail

echo "🔓 Applying secrets..."

export SOPS_AGE_KEY_FILE="$HOME/.config/age/key.txt"
mkdir -p "$HOME/.local/share/secrets"
applied=0

for file in secrets/**/*.sops.yaml; do
    if [[ -f "$file" && ! "$file" =~ examples/ ]]; then
        echo "Decrypting: $file"
        basename=$(basename "$file" .sops.yaml)
        output="$HOME/.local/share/secrets/$basename.yaml"
        if sops -d "$file" > "$output"; then
            echo "  ✓ Decrypted to: $output"
            applied=$((applied + 1))
        else
            echo "  ✗ Failed to decrypt: $file"
        fi
    fi
done

echo ""
if [[ $applied -gt 0 ]]; then
    echo "✓ Applied $applied secret files to ~/.local/share/secrets/"
    echo "💡 Source them in your shell or applications as needed"
else
    echo "💡 No secret files found to apply (*.sops.yaml in secrets/ excluding examples/)"
fi