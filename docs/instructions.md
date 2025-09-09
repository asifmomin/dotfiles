# Installation & Setup Instructions

Complete guide for installing and configuring the dotfiles system on any supported platform.

## Prerequisites

### System Requirements

- **Operating System**: macOS, Linux, or WSL
- **Required Tools**: git, curl (usually pre-installed)
- **Network**: Internet connection for downloading packages
- **Permissions**: Ability to install software (sudo/admin access)

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
5. Initialize secrets management

### Method 2: Manual Installation

```bash
# 1. Clone the repository
git clone https://github.com/asifmomin/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run the bootstrap process
just bootstrap

# 3. Restart your shell
exec $SHELL
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
exec $SHELL
```

## Post-Installation Setup

### 1. Configure Git Identity

#### Global Default Identity
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### Work Directory Setup (Optional)
```bash
mkdir -p ~/work
git config --file ~/.config/git/config-work user.name "Your Work Name"
git config --file ~/.config/git/config-work user.email "work@company.com"
```

#### Personal Directory Setup (Optional)
```bash
mkdir -p ~/per
git config --file ~/.config/git/config-personal user.name "Your Personal Name"
git config --file ~/.config/git/config-personal user.email "personal@gmail.com"
```

### 2. Setup Secrets Management (Optional)

```bash
# Generate age keys and configure SOPS
just secrets-init

# Create your first secret file
just secrets-edit secrets/env/github.sops.yaml

# Apply secrets
just secrets-apply
```

### 3. Configure Shell as Default

#### Zsh as Default Shell
```bash
# Add zsh to valid login shells
echo $(which zsh) | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which zsh)
```

### 4. Terminal Configuration

#### Alacritty Setup
- Alacritty config is automatically applied via stow
- Font: CaskaydiaMono Nerd Font (installed via Homebrew)
- Theme: Tokyo Night with transparency

#### Terminal Font
If you prefer a different terminal, install the required font:
```bash
# Font is already installed via Homebrew
# For other terminals, configure to use: CaskaydiaMono Nerd Font
```

## Customization

### 1. Personal Shell Customizations

```bash
# Copy example local config
cp ~/.config/zsh/local.zsh.example ~/.config/zsh/local.zsh

# Edit with your customizations
nvim ~/.config/zsh/local.zsh
```

Example `local.zsh`:
```bash
# Personal aliases
alias work='cd ~/work'
alias projects='cd ~/projects'

# Custom environment variables
export EDITOR="code"  # Use VS Code instead of Neovim

# Custom functions
deploy() {
    echo "Deploying to $1..."
    # Your deployment logic
}
```

### 2. Starship Prompt Customization

```bash
# Switch to minimal prompt (Omarchy style)
prompt-switch minimal

# Switch to full-featured prompt
prompt-switch full

# Create custom prompt
cp ~/.config/starship.toml ~/.config/starship-custom.toml
nvim ~/.config/starship-custom.toml
prompt-switch custom
```

### 3. Neovim Customization

Following Omarchy's philosophy, customizations should be minimal:

```bash
# Create personal overrides (if needed)
nvim ~/.config/nvim/lua/plugins/personal.lua
```

Example minimal customization:
```lua
-- lua/plugins/personal.lua
return {
  -- Add only essential personal plugins
}
```

### 4. Git Configuration

#### Additional Git Aliases
```bash
# Add to ~/.config/git/config
[alias]
    pushf = push --force-with-lease
    wip = commit -am "WIP"
```

#### GPG Signing (Advanced)
```bash
# Configure GPG signing
git config --global user.signingkey YOUR_GPG_KEY_ID
git config --global commit.gpgsign true
```

## Platform-Specific Setup

### macOS Additional Steps

```bash
# Install additional macOS apps (optional)
brew install --cask iterm2 visual-studio-code

# Configure macOS defaults (optional)
defaults write com.apple.dock autohide -bool true
defaults write com.apple.finder ShowPathbar -bool true
```

### Linux Additional Steps

```bash
# Install clipboard utilities for pbcopy/pbpaste aliases
# (Usually installed automatically via Brewfile)

# Configure desktop environment (varies by distribution)
# The dotfiles work with any desktop environment
```

### WSL Additional Steps

```bash
# Configure Windows Terminal (optional)
# The dotfiles include Windows Terminal integration

# Set up Windows integration
# Windows commands are available via shell aliases
```

## Verification

### Health Check

```bash
# Run comprehensive health check
just doctor
```

Expected output:
```
🔍 Running dotfiles health check...

Platform: linux ✓

Required tools:
  git: ✓
  stow: ✓
  brew: ✓
  zsh: ✓
  starship: ✓
  nvim: ✓

Optional tools:
  just: ✓
  sops: ✓
  age: ✓
  fzf: ✓
  ripgrep: ✓
  bat: ✓
  eza: ✓
  fd: ✓
  btop: ✓
  tmux: ✓
```

### Manual Verification

```bash
# Test shell functionality
echo $SHELL  # Should show zsh path
which starship  # Should show starship path

# Test git configuration
cd ~/work && git config user.email  # Should show work email
cd ~/per && git config user.email   # Should show personal email

# Test theme consistency
bat --theme  # Should show TwoDark
btop  # Should show Tokyo Night theme (press 'q' to quit)

# Test secrets (if configured)
just secrets-show secrets/examples/github-tokens.sops.yaml
```

## Troubleshooting

### Common Issues

#### 1. Stow Conflicts
**Problem**: Existing files conflict with stow packages
**Solution**: 
```bash
# Back up existing configs
mkdir ~/dotfiles-backup
mv ~/.zshrc ~/dotfiles-backup/
mv ~/.config/nvim ~/dotfiles-backup/

# Retry stow
just stow-apply
```

#### 2. Shell Not Changing
**Problem**: Default shell remains bash
**Solution**:
```bash
# Verify zsh is in valid shells
cat /etc/shells | grep zsh

# Add if missing
echo $(which zsh) | sudo tee -a /etc/shells

# Change shell
chsh -s $(which zsh)

# Restart terminal
```

#### 3. Homebrew Installation Failed
**Problem**: Homebrew installation fails
**Solution**:
```bash
# Install Homebrew manually
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH (Linux/WSL)
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Retry bootstrap
just bootstrap
```

#### 4. Font Issues
**Problem**: Terminal shows squares instead of icons
**Solution**:
```bash
# Verify font installation
brew list | grep font-caskaydia

# Configure terminal to use CaskaydiaMono Nerd Font
# Instructions vary by terminal application
```

#### 5. Git Directory Switching Not Working
**Problem**: Git identity doesn't switch by directory
**Solution**:
```bash
# Check Git version (requires 2.13+)
git --version

# Test conditional includes
cd ~/work && git config --list --show-origin | grep user

# Verify config files exist
ls ~/.config/git/config*
```

### Getting Help

1. **Check documentation**: See other files in `docs/`
2. **Run health check**: `just doctor`
3. **Check git history**: Recent changes and solutions
4. **File issues**: Create GitHub issues for bugs
5. **Check logs**: `~/.local/state/zsh/history` for shell issues

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

## Next Steps

After successful installation:

1. **Explore tools**: Try `bat`, `eza`, `btop`, etc.
2. **Create projects**: Test direnv with `mkdir ~/work/test-project`
3. **Setup secrets**: Configure encrypted secrets for your workflow
4. **Customize**: Add personal touches via local configs
5. **Share**: Fork and adapt for your team's needs

The dotfiles system is designed to be a solid foundation that you can build upon while maintaining the core minimal philosophy inspired by Omarchy.