# Installation & Setup Instructions

Complete guide for installing and configuring the dotfiles system.

> **Quick Start?** See [QUICKSTART.md](./QUICKSTART.md) for a 5-minute setup guide.

## Prerequisites

### System Requirements

- **Operating System**: macOS, Linux, or WSL
- **Required Tools**: git, curl (usually pre-installed)
- **Network**: Internet connection for downloading packages
- **Permissions**: Ability to install software (sudo for `chsh` only)

### Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| macOS | ✅ Full Support | Homebrew native platform |
| Ubuntu/Debian | ✅ Full Support | Via Homebrew on Linux |
| Fedora/RHEL | ✅ Full Support | Via Homebrew on Linux |
| Arch Linux | ✅ Full Support | Via Homebrew on Linux |
| WSL (Ubuntu) | ✅ Full Support | Recommended WSL distribution |
| WSL (Other) | ⚠️ Limited Testing | Should work but not extensively tested |

## Installation Methods

### Method 1: One-Line Bootstrap (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/asifmomin/dotfiles/main/bootstrap.sh | bash
```

This will:
1. Install Homebrew if not present
2. Clone the dotfiles repository to `~/dotfiles`
3. Install all required packages
4. Apply all configuration packages via stow
5. Setup shell environment

**After installation completes, restart your shell:**
```bash
exec zsh
```

### Method 2: Manual Installation

```bash
# 1. Clone the repository
git clone https://github.com/asifmomin/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run the bootstrap process
just bootstrap

# 3. Restart your shell
exec zsh
```

### Method 3: Step-by-Step Installation

For maximum control over the installation process:

```bash
# 1. Clone repository
git clone https://github.com/asifmomin/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Install packages
just install-packages

# 3. Check what stow will do (dry run)
just stow-check

# 4. Apply configurations
just stow-apply

# 5. Initialize secrets (optional)
just secrets-init

# 6. Verify installation
just doctor

# 7. Restart shell
exec zsh
```

## Post-Installation Setup

### 1. Configure Git Identity

#### Global Default Identity
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### Directory-Based Identity (Recommended)

Setup automatic work/personal identity switching:

```bash
# Work identity
mkdir -p ~/work
git config --file ~/.config/git/config-work user.name "Work Name"
git config --file ~/.config/git/config-work user.email "work@company.com"

# Personal identity
mkdir -p ~/per
git config --file ~/.config/git/config-personal user.name "Personal Name"
git config --file ~/.config/git/config-personal user.email "personal@email.com"
```

See [Git Directory Switching](./git-directory-switching.md) for detailed guide.

### 2. Setup Secrets Management (Optional)

```bash
# Generate age keys and configure SOPS
just secrets-init

# Create your first secret file
just secrets-edit f=secrets/env/github.sops.yaml

# Add your secrets (file opens in editor)
GITHUB_TOKEN=ghp_xxxxx
API_KEY=xxxxx

# Apply secrets
just secrets-apply
```

### 3. Set Zsh as Default Shell

```bash
# Add zsh to valid login shells (if needed)
echo $(which zsh) | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which zsh)

# Restart terminal
```

## Customization

### Personal Shell Configuration

Create `~/.config/zsh/local.zsh` for personal customizations:

```bash
# Copy example config
cp ~/.config/zsh/local.zsh.example ~/.config/zsh/local.zsh

# Edit with your customizations
nvim ~/.config/zsh/local.zsh
```

Example customizations:
```bash
# Personal aliases
alias work='cd ~/work'
alias projects='cd ~/projects'

# Environment variables
export EDITOR="code"  # Use VS Code instead of Neovim

# Custom functions
deploy() {
    echo "Deploying to $1..."
    # Your logic here
}
```

### Prompt Customization

Switch between prompt styles:

```bash
# Minimal prompt (Omarchy-style)
prompt-switch minimal

# Full-featured prompt
prompt-switch full

# Create custom prompt
cp ~/.config/starship.toml ~/.config/starship-custom.toml
nvim ~/.config/starship-custom.toml
prompt-switch custom
```

### Runtime Version Management (mise)

Use mise for automatic language version management:

```bash
# In your project directory
cd ~/work/my-project

# Specify versions in .tool-versions
echo "node 20.10.0" > .tool-versions
echo "python 3.12.0" >> .tool-versions
echo "ruby 3.3.0" >> .tool-versions

# mise automatically installs and switches versions when you cd
```

### Per-Directory Environments (direnv)

Create project-specific environments:

```bash
# In your project directory
cd ~/work/my-project

# Create .envrc file
cat > .envrc << 'EOF'
export DATABASE_URL=postgresql://localhost/mydb
export API_KEY=$(cat ~/.local/share/secrets/api-key.txt)
layout python3  # Activates Python virtualenv
EOF

# Allow direnv to load
direnv allow
```

## Verification

### Health Check

```bash
# Run comprehensive health check
just doctor
```

Expected output:
```
✓ Platform detected: linux
✓ All required tools installed
✓ Configuration files linked
✓ Shell environment ready
```

### Manual Testing

```bash
# Test shell functionality
echo $SHELL  # Should show zsh path
which starship eza bat  # Should show installed tools

# Test Git directory switching
cd ~/work && git config user.email  # Should show work email
cd ~/per && git config user.email   # Should show personal email

# Test modern CLI tools
ls  # Enhanced with eza
cat README.md  # Enhanced with bat
```

## Platform-Specific Notes

### macOS

```bash
# Install additional macOS apps (optional)
brew install --cask visual-studio-code iterm2

# Configure macOS defaults (optional)
defaults write com.apple.dock autohide -bool true
defaults write com.apple.finder ShowPathbar -bool true
```

### Linux

```bash
# Clipboard utilities installed automatically
# pbcopy/pbpaste aliases work via xclip

# The dotfiles work with any desktop environment
```

### WSL

```bash
# Windows integration commands available
explorer .  # Open Windows Explorer
cmd         # Open Windows CMD
powershell  # Open PowerShell

# Configure Windows Terminal for best experience
```

## Troubleshooting

### Common Issues

#### Shell Not Changing

**Problem**: Default shell remains bash

**Solution**:
```bash
# Verify zsh is in valid shells
cat /etc/shells | grep zsh

# Add if missing
echo $(which zsh) | sudo tee -a /etc/shells

# Change shell and restart terminal
chsh -s $(which zsh)
```

#### Stow Conflicts

**Problem**: Existing files conflict with stow packages

**Solution**:
```bash
# Back up existing configs
mkdir ~/dotfiles-backup
mv ~/.zshrc ~/.config/nvim ~/dotfiles-backup/

# Retry stow
just stow-apply
```

#### Homebrew Issues

**Problem**: Homebrew not found or installation failed

**Solution**:
```bash
# Install Homebrew manually
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"  # macOS
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  # Linux/WSL

# Retry bootstrap
just bootstrap
```

#### Font/Icon Issues

**Problem**: Terminal shows squares instead of icons

**Solution**:
- Configure your terminal to use **CaskaydiaMono Nerd Font**
- Font is already installed via Homebrew
- For Alacritty, font is pre-configured

#### Git Identity Not Switching

**Problem**: Git identity doesn't switch by directory

**Solution**:
```bash
# Check Git version (requires 2.13+)
git --version

# Verify config files exist
ls ~/.config/git/config*

# Test conditional includes
cd ~/work && git config --list | grep user
```

### Getting Help

1. **Check FAQ**: See [FAQ.md](./FAQ.md) for common questions
2. **Run health check**: `just doctor`
3. **Review documentation**: Check other docs in `docs/`
4. **File an issue**: [GitHub Issues](https://github.com/asifmomin/dotfiles/issues)

### Recovery

If something goes wrong, you can easily recover:

```bash
# Remove all configurations
just stow-remove

# Clean up broken symlinks
just clean

# Restore from backup
cp -r ~/dotfiles-backup/* ~/

# Or start fresh
rm -rf ~/dotfiles
# Run installation again
```

## Advanced Configuration

### Different SSH Keys for Work/Personal

```bash
# Work SSH key
git config --file ~/.config/git/config-work core.sshCommand "ssh -i ~/.ssh/id_work"

# Personal SSH key
git config --file ~/.config/git/config-personal core.sshCommand "ssh -i ~/.ssh/id_personal"
```

### GPG Commit Signing

```bash
# Configure GPG signing
git config --global user.signingkey YOUR_GPG_KEY_ID
git config --global commit.gpgsign true
```

### Selective Package Installation

```bash
# Apply only specific packages
stow -d packages -t ~ shell  # Only shell configs
stow -d packages -t ~ git    # Only git configs
stow -d packages -t ~ neovim # Only neovim configs

# Remove specific package
stow -d packages -t ~ -D tmux
```

## Next Steps

After successful installation:

1. **Explore the tools** - Try the enhanced CLI experience
2. **Create projects** - Test mise and direnv in real projects
3. **Setup secrets** - Configure encrypted secrets for your workflow
4. **Customize** - Add personal touches via local configs
5. **Share** - Fork and adapt for your team

See [QUICKSTART.md](./QUICKSTART.md) for quick commands and [FAQ.md](./FAQ.md) for common questions.

---

The dotfiles system provides a solid foundation inspired by Omarchy's minimal philosophy while supporting modern development workflows.
