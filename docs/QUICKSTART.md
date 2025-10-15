# Quick Start Guide

Get up and running with this dotfiles configuration in under 5 minutes.

## 1. Install (5 minutes)

### One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/asifmomin/dotfiles/main/bootstrap.sh | bash
```

This will:
- Install Homebrew (if not present)
- Clone dotfiles to `~/dotfiles`
- Install all packages
- Apply configurations via stow
- Setup shell environment

### Manual Installation

```bash
git clone https://github.com/asifmomin/dotfiles.git ~/dotfiles
cd ~/dotfiles
just bootstrap
```

## 2. Configure Git Identity

### Global Default

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Work Directory (Optional)

For automatic work/personal identity switching:

```bash
# Create work directory
mkdir -p ~/work

# Configure work identity
git config --file ~/.config/git/config-work user.name "Work Name"
git config --file ~/.config/git/config-work user.email "work@company.com"
```

### Personal Directory (Optional)

```bash
# Create personal directory
mkdir -p ~/per

# Configure personal identity
git config --file ~/.config/git/config-personal user.name "Personal Name"
git config --file ~/.config/git/config-personal user.email "personal@email.com"
```

Now repos in `~/work/*` use work identity, `~/per/*` use personal identity automatically!

## 3. Verify Installation

```bash
# Run health check
just doctor

# Restart shell to load new configuration
exec zsh
```

Expected output:
```
✓ Platform detected
✓ All required tools installed
✓ Configuration applied
```

## 4. Start Using

Try these commands to see the enhanced experience:

### File Operations
```bash
ls                  # Enhanced listing with icons (eza)
cat README.md       # Syntax-highlighted viewing (bat)
find . -name "*.md" # Fast file search (fd)
grep "TODO"         # Fast text search (ripgrep)
```

### Git Workflow
```bash
g st                # git status
ga .                # git add .
gcm "message"       # git commit -m "message"
gp                  # git push
```

### System Monitoring
```bash
top                 # Modern system monitor (btop)
du                  # Disk usage analyzer (dust)
```

### Package Management
```bash
brewup              # Update all Homebrew packages
brewi <package>     # Install package
brews <query>       # Search packages
```

## 5. Customize (Optional)

### Personal Shell Configuration

```bash
# Copy example config
cp ~/.config/zsh/local.zsh.example ~/.config/zsh/local.zsh

# Add your customizations
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
}
```

### Prompt Style

```bash
# Switch to minimal prompt (Omarchy-style)
prompt-switch minimal

# Switch to full-featured prompt
prompt-switch full
```

## 6. Explore Features

### Secrets Management

```bash
# Initialize secrets
just secrets-init

# Create encrypted secret file
just secrets-edit f=secrets/env/github.sops.yaml

# Apply secrets
just secrets-apply
```

### Project Runtime Management with mise

Python 3.12 LTS and Node.js LTS are pre-installed globally. For project-specific versions:

```bash
# Check installed versions
mise list

# In any project directory, create .tool-versions for custom versions
cd ~/work/my-project
echo "node 20.10.0" > .tool-versions
echo "python 3.11.0" >> .tool-versions

# mise automatically installs and switches versions when you cd into the directory
```

### Directory-Based Environments with direnv

```bash
# Create project-specific environment
cd ~/work/my-project
echo "export DATABASE_URL=postgresql://localhost/mydb" > .envrc
direnv allow

# Variables auto-load when you enter the directory
```

## Next Steps

- **[Complete Installation Guide](./instructions.md)** - Detailed setup and customization
- **[Shell Aliases Reference](../packages/shell/ALIASES.md)** - All 60+ shortcuts
- **[Git Directory Switching](./git-directory-switching.md)** - Advanced Git identity setup
- **[Philosophy & Design](./PHILOSOPHY.md)** - Understand the design principles
- **[FAQ](./FAQ.md)** - Common questions and troubleshooting

## Essential Commands Reference

### Dotfiles Management
```bash
just bootstrap        # Full setup (initial install)
just doctor          # Health check all tools
just update          # Update packages and dotfiles
just stow-check      # Preview config changes
just stow-apply      # Apply configurations
just stow-restow     # Reapply configurations
just clean           # Remove broken symlinks
```

### Secrets Management
```bash
just secrets-init    # Generate age keys
just secrets-edit f= # Edit encrypted file
just secrets-show f= # View decrypted content
just secrets-apply   # Apply all secrets
```

## Troubleshooting

### Shell not changing?
```bash
# Add zsh to valid shells
echo $(which zsh) | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which zsh)

# Restart terminal
```

### Icons not showing?
- Configure your terminal to use **CaskaydiaMono Nerd Font**
- Font is already installed via Homebrew

### Git identity not switching?
```bash
# Verify config files exist
ls ~/.config/git/config*

# Test in work directory
cd ~/work && git config user.email
```

### Need more help?
- Check **[FAQ](./FAQ.md)**
- Run `just doctor` for diagnostics
- Review **[Full Instructions](./instructions.md)**

---

**You're all set!** Enjoy your minimal, modern development environment inspired by Omarchy. 🚀
