# Secrets Management

Encrypted secrets management using SOPS and age encryption.

## Overview

This directory contains encrypted configuration files for sensitive data like API tokens, SSH keys, and environment variables. All secrets are encrypted using [SOPS](https://github.com/mozilla/sops) with [age](https://age-encryption.org/) encryption.

## Structure

```
secrets/
├── README.md           # This documentation
├── ssh/               # SSH configuration secrets  
├── env/               # Environment variable secrets
└── examples/          # Example secret files
```

## Quick Start

### 1. Initialize Secrets Management
```bash
# Generate age key and configure SOPS
just secrets:init
```

This will:
- Generate a new age key pair
- Display your public key
- Update `.sops.yaml` with your public key
- Create the age key directory

### 2. Create Your First Secret
```bash
# Create an encrypted file
just secrets:edit secrets/env/github.sops.yaml
```

### 3. Apply Secrets (Decrypt and Use)
```bash
# Decrypt and apply secrets
just secrets:apply
```

## Commands

### Initialize
```bash
just secrets:init       # Generate keys and setup
```

### Edit Secrets
```bash
just secrets:edit secrets/env/github.sops.yaml    # Edit encrypted file
just secrets:edit secrets/ssh/config.sops.yaml    # Edit SSH config
```

### Apply Secrets
```bash
just secrets:apply      # Decrypt and apply all secrets
```

### View Secrets (Decrypted)
```bash
just secrets:show secrets/env/github.sops.yaml    # Show decrypted content
```

## Example Secret Files

### GitHub Tokens (`secrets/env/github.sops.yaml`)
```yaml
# Encrypted GitHub API tokens
github:
  token: "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  username: "yourusername"
  
npm:
  token: "npm_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

### SSH Configuration (`secrets/ssh/config.sops.yaml`)
```yaml
# Encrypted SSH configuration
ssh_config: |
  Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    
  Host work-server
    HostName server.company.com
    User myusername
    Port 2222
    IdentityFile ~/.ssh/work_key
```

### Environment Variables (`secrets/env/development.sops.yaml`)
```yaml
# Development environment secrets
env_vars:
  DATABASE_URL: "postgresql://user:pass@localhost:5432/mydb"
  API_KEY: "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  JWT_SECRET: "your-super-secret-jwt-key"
```

## Security

### Age Encryption
- Uses modern age encryption (replacement for GPG)
- Each file encrypted with your age public key
- Private key stored securely in `~/.config/age/`
- No password required after initial setup

### Best Practices
1. **Never commit unencrypted secrets** to git
2. **Backup your age private key** securely
3. **Use specific secret files** rather than one large file
4. **Rotate secrets regularly**
5. **Use environment-specific secret files**

### Key Management
```bash
# Backup your private key
cp ~/.config/age/key.txt ~/backup/age-key-backup.txt

# View your public key
cat ~/.config/age/key.txt | grep "# public key:" | cut -d: -f2 | xargs
```

## Integration

### Shell Integration
Secrets can be loaded into shell environment:

```bash
# In .zshrc or .bashrc (after secrets are applied)
if [[ -f ~/.local/share/secrets/env.sh ]]; then
  source ~/.local/share/secrets/env.sh
fi
```

### Application Integration
Applications can read decrypted secrets:

```bash
# Read GitHub token
GITHUB_TOKEN=$(yq '.github.token' ~/.local/share/secrets/github.yaml)

# Use in scripts
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

### CI/CD Integration
For automated environments:

```bash
# Set age private key in CI environment
export SOPS_AGE_KEY="AGE-SECRET-KEY-1..."

# Decrypt and use secrets
sops -d secrets/env/production.sops.yaml > /tmp/secrets.yaml
```

## File Naming

Use consistent naming patterns:

- **Environment files**: `secrets/env/{environment}.sops.yaml`
- **SSH files**: `secrets/ssh/{purpose}.sops.yaml`  
- **Service files**: `secrets/{service}/{config}.sops.yaml`

Examples:
- `secrets/env/development.sops.yaml`
- `secrets/env/production.sops.yaml`
- `secrets/ssh/personal.sops.yaml`
- `secrets/ssh/work.sops.yaml`
- `secrets/github/tokens.sops.yaml`
- `secrets/aws/credentials.sops.yaml`

## Troubleshooting

### Key Not Found
```bash
# Check if age key exists
ls ~/.config/age/key.txt

# Regenerate if missing
just secrets:init
```

### SOPS Errors
```bash
# Verify SOPS configuration
cat .sops.yaml

# Check file encryption
sops -d secrets/env/example.sops.yaml
```

### Decryption Issues
```bash
# Verify age key permissions
chmod 600 ~/.config/age/key.txt

# Test decryption manually
age -d -i ~/.config/age/key.txt secrets/env/example.sops.yaml
```

## Migration

### From GPG to Age
If migrating from GPG-based SOPS:

```bash
# Decrypt with GPG
sops -d old-secrets.yaml > temp-secrets.yaml

# Re-encrypt with age
sops -e temp-secrets.yaml > new-secrets.sops.yaml

# Clean up
rm temp-secrets.yaml
```

### From Environment Files
If migrating from `.env` files:

```bash
# Convert .env to YAML
echo "env_vars:" > secrets.yaml
sed 's/=/: /' .env | sed 's/^/  /' >> secrets.yaml

# Encrypt
sops -e secrets.yaml > secrets/env/converted.sops.yaml
```

## Resources

- [SOPS Documentation](https://github.com/mozilla/sops)
- [Age Encryption](https://age-encryption.org/)
- [YAML Reference](https://yaml.org/)