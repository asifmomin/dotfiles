#!/usr/bin/env bash
set -euo pipefail

# Secrets management functions for dotfiles

# Initialize secrets management (generate age keys)
secrets_init() {
    echo "🔐 Initializing secrets management..."
    
    if ! command -v age >/dev/null 2>&1; then
        echo "❌ age is not installed. Run 'just install-packages' first."
        exit 1
    fi
    
    if ! command -v sops >/dev/null 2>&1; then
        echo "❌ sops is not installed. Run 'just install-packages' first."
        exit 1
    fi
    
    age_key="$HOME/.config/age/key.txt"
    if [[ ! -f "$age_key" ]]; then
        echo "Generating age key..."
        mkdir -p "$(dirname "$age_key")"
        age-keygen -o "$age_key"
        chmod 600 "$age_key"
        echo "✓ Age key generated: $age_key"
    else
        echo "✓ Age key already exists: $age_key"
    fi
    
    public_key=$(grep -o 'age1[a-zA-Z0-9]*' "$age_key")
    echo ""
    echo "Your age public key: $public_key"
    echo ""
    
    if grep -q "age1PLACEHOLDER" .sops.yaml; then
        echo "Updating .sops.yaml with your public key..."
        sed -i.bak "s/age1PLACEHOLDER_REPLACE_WITH_YOUR_PUBLIC_KEY_AFTER_RUNNING_secrets_init/$public_key/g" .sops.yaml
        rm .sops.yaml.bak
        echo "✓ .sops.yaml updated with your public key"
    else
        echo "💡 .sops.yaml already configured or needs manual update"
    fi
    
    echo ""
    echo "✅ Secrets management initialized!"
    echo ""
    echo "Next steps:"
    echo "  1. Create encrypted files: just secrets-edit secrets/env/example.sops.yaml"
    echo "  2. Apply secrets: just secrets-apply"
}

# Edit encrypted file with sops
secrets_edit() {
    local file="$1"
    echo "✏️  Editing encrypted file: $file"
    
    if [[ ! -f "$file" ]]; then
        echo "Creating new encrypted file: $file"
        mkdir -p "$(dirname "$file")"
        echo "# Encrypted secrets file" > "$file"
    fi
    
    sops "$file"
}

# Show decrypted content of a secret file
secrets_show() {
    local file="$1"
    echo "👁️  Showing decrypted content: $file"
    export SOPS_AGE_KEY_FILE="$HOME/.config/age/key.txt"
    sops -d "$file"
}

# Main function to handle script invocation
main() {
    local cmd="${1:-}"
    shift || true
    
    case "$cmd" in
        init)
            secrets_init "$@"
            ;;
        edit)
            secrets_edit "$@"
            ;;
        show)
            secrets_show "$@"
            ;;
        *)
            echo "Usage: $0 {init|edit|show} [args...]"
            exit 1
            ;;
    esac
}

# Only run main if this script is being executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi