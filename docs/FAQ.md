# Frequently Asked Questions

## Installation & Setup

### Do I need sudo/root access?

Only for changing your default shell with `chsh`. Homebrew package installation runs in user space and doesn't require sudo (on Linux/WSL, Homebrew installs to user directory).

### Can I use this with my existing dotfiles?

Yes! Back up your existing configurations first, then you can selectively apply individual packages:

```bash
# Back up existing configs
mkdir ~/dotfiles-backup
mv ~/.zshrc ~/.config/nvim ~/dotfiles-backup/

# Apply specific packages only
cd ~/dotfiles
stow -d packages -t ~ shell  # Only shell configs
stow -d packages -t ~ git    # Only git configs
```

### How do I uninstall everything?

```bash
# Remove all symlinks
cd ~/dotfiles
just stow-remove

# Optionally remove the repository
rm -rf ~/dotfiles

# Change shell back to bash (if desired)
chsh -s /bin/bash
```

### Can I install this on multiple machines?

Absolutely! That's the point. Just run the bootstrap on each machine:

```bash
curl -fsSL https://raw.githubusercontent.com/asifmomin/dotfiles/main/bootstrap.sh | bash
```

Your configurations will be identical across all machines.

### Do I need to install all the tools?

No. The dotfiles gracefully degrade. If a tool isn't installed, aliases fallback to standard commands. But for the best experience, install everything via `just install-packages`.

## Configuration

### How do I customize the shell prompt?

Use the built-in prompt switcher:

```bash
# Minimal prompt (Omarchy-style)
prompt-switch minimal

# Full-featured prompt
prompt-switch full

# Or edit directly
nvim ~/.config/starship.toml
```

### Can I use VS Code instead of Neovim?

Yes! Add this to `~/.config/zsh/local.zsh`:

```bash
export EDITOR="code"
export VISUAL="code"
```

### Where do I add personal aliases and functions?

Create `~/.config/zsh/local.zsh` for your personal customizations:

```bash
# Copy the example
cp ~/.config/zsh/local.zsh.example ~/.config/zsh/local.zsh

# Edit it
nvim ~/.config/zsh/local.zsh
```

This file is gitignored and won't be overwritten by updates.

### How do I change the terminal theme?

The Tokyo Night theme is applied by default. To customize:

- **Colors**: Edit `~/.config/alacritty/alacritty.toml`
- **Neovim**: Theme set in `~/.config/nvim/lua/config/lazy.lua`
- **Shell**: FZF colors in `~/.config/zsh/.zshrc`

### Can I disable certain packages?

Yes. Simply don't stow them:

```bash
# Remove a package
stow -d packages -t ~ -D tmux  # Remove tmux config

# Or manually delete symlinks
rm ~/.config/tmux
```

## Git & Version Control

### How does Git directory switching work?

Git automatically uses different identities based on directory:

- `~/work/*` → Work identity
- `~/per/*` → Personal identity
- Other directories → Global identity

Setup: See [Git Directory Switching](./git-directory-switching.md#quick-setup)

### Can I use different SSH keys for work/personal?

Yes! Add to your Git config files:

```bash
# Work SSH key
git config --file ~/.config/git/config-work core.sshCommand "ssh -i ~/.ssh/id_work"

# Personal SSH key
git config --file ~/.config/git/config-personal core.sshCommand "ssh -i ~/.ssh/id_personal"
```

### Why am I committing with the wrong email?

Check which directory you're in. The Git identity switches based on location:

```bash
pwd  # Check current directory
git config user.email  # Check current identity

# Move project to correct directory
mv ~/projects/work-stuff ~/work/
```

## Secrets Management

### How do I manage API keys and tokens?

Use SOPS for encrypted secrets:

```bash
# Initialize secrets
just secrets-init

# Create encrypted file
just secrets-edit f=secrets/env/github.sops.yaml

# Add your secrets (file opens in editor)
GITHUB_TOKEN=ghp_xxxxx
API_KEY=xxxxx

# Apply secrets
just secrets-apply
```

Secrets are encrypted and safe to commit to git.

### Can I share secrets with my team?

Yes! SOPS supports multiple recipients. Add team members' age public keys to `.sops.yaml`:

```yaml
creation_rules:
  - path_regex: secrets/.*\.yaml$
    age: >-
      age1xxxxx,  # Your key
      age1yyyyy,  # Team member 1
      age1zzzzz   # Team member 2
```

### Where are decrypted secrets stored?

Decrypted secrets go to `~/.local/share/secrets/` and are never committed to git.

## Runtime Management (mise)

### What is mise?

mise (formerly rtx) is a runtime version manager that replaces tools like nvm, rbenv, pyenv, etc. It reads `.tool-versions` files in your projects and automatically switches to the correct language versions.

### How do I use mise?

```bash
# In your project
cd ~/work/my-project

# Specify versions
echo "node 20.10.0" > .tool-versions
echo "python 3.12.0" >> .tool-versions

# mise auto-installs when you cd into directory
cd ~/work/my-project  # Versions automatically activated
```

### Does mise replace Docker?

No. mise manages language runtimes (Node, Python, Ruby, etc). Use Docker for full application environments. They complement each other.

### Can I use nvm/rbenv alongside mise?

It's possible but not recommended. mise can handle everything those tools do. For migration:

```bash
# Convert from nvm
echo "node $(node --version | sed 's/v//')" > .tool-versions

# Convert from rbenv
echo "ruby $(ruby --version | awk '{print $2}')" >> .tool-versions
```

## Troubleshooting

### Shell startup is slow

Identify the bottleneck:

```bash
zsh -xvs 2>&1 | head -50
```

Common causes:
- Too many plugins loaded
- Slow network checks
- Large history file

### Icons/glyphs not showing in terminal

Install and configure a Nerd Font:

```bash
# Font already installed via Homebrew
brew list | grep font-caskaydia

# Configure your terminal to use: CaskaydiaMono Nerd Font
```

For Alacritty, the font is already configured.

### Git identity not switching

Check these:

```bash
# 1. Verify Git version (need 2.13+)
git --version

# 2. Verify config files exist
ls ~/.config/git/config*

# 3. Test in work directory
cd ~/work && git config --list | grep user

# 4. Check directory path in config
cat ~/.config/git/config | grep includeIf
```

### Commands not found after installation

Ensure Homebrew is in your PATH:

```bash
# Check if brew is available
which brew

# If not found, add to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"  # macOS
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  # Linux/WSL

# Restart shell
exec zsh
```

### Stow conflicts with existing files

Back up and remove conflicting files:

```bash
# Identify conflicts
just stow-check

# Back up existing configs
mkdir ~/dotfiles-backup
mv ~/.zshrc ~/.config/nvim ~/dotfiles-backup/

# Retry stow
just stow-apply
```

### Package installation fails on Linux/WSL

Install build essentials first:

```bash
# Ubuntu/Debian
sudo apt-get install build-essential

# Fedora/RHEL
sudo dnf groupinstall "Development Tools"

# Then retry
just install-packages
```

## Advanced Usage

### Can I use this in a Docker container?

Yes! The dotfiles work great in containers:

```dockerfile
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl git sudo

# Run bootstrap
RUN curl -fsSL https://raw.githubusercontent.com/asifmomin/dotfiles/main/bootstrap.sh | bash

# Set zsh as default
CMD ["/bin/zsh"]
```

### How do I keep my dotfiles fork updated?

```bash
# Add upstream remote
git remote add upstream https://github.com/asifmomin/dotfiles.git

# Fetch and merge updates
git fetch upstream
git merge upstream/main

# Resolve conflicts with your customizations
# Push to your fork
git push origin main
```

### Can I selectively update packages?

Yes:

```bash
# Update only specific packages
brew upgrade bat eza ripgrep

# Update everything else
just update
```

### How do I contribute improvements?

1. Fork the repository
2. Create a feature branch
3. Make your changes (follow existing patterns)
4. Test on all platforms (macOS, Linux, WSL)
5. Submit a pull request

See [PHILOSOPHY.md](./PHILOSOPHY.md) for design principles.

## Platform-Specific

### macOS: How do I configure system preferences?

Add to `~/.config/zsh/local.zsh`:

```bash
# Example macOS preferences
defaults write com.apple.dock autohide -bool true
defaults write com.apple.finder ShowPathbar -bool true
```

### Linux: How do I setup clipboard support?

xclip is installed automatically. The aliases `pbcopy` and `pbpaste` work like macOS:

```bash
echo "hello" | pbcopy
pbpaste
```

### WSL: How do I access Windows files?

```bash
# Windows C: drive
cd /mnt/c/Users/YourName

# Aliases provided for convenience
explorer .  # Open Windows Explorer
cmd         # Open Windows CMD
powershell  # Open PowerShell
```

## Philosophy & Design

### Why Omarchy-inspired?

Omarchy demonstrates that minimal configurations are more maintainable and performant. We extend this philosophy with modern development requirements while keeping the minimal approach.

### Why Tokyo Night theme?

Professional dark theme with excellent readability and wide tool support. Provides visual consistency across all development tools.

### Why Homebrew on Linux?

Consistency across platforms. Same packages, same versions, same commands on macOS, Linux, and WSL.

### Can I fork this for my team?

Absolutely! That's encouraged. Fork, customize, and adapt. Keep the attribution in [CREDITS.md](./CREDITS.md).

## Getting More Help

Still need help?

1. **Check documentation**: [docs/](../docs/)
2. **Run health check**: `just doctor`
3. **Review examples**: See `secrets/examples/`
4. **Read tool docs**: Check individual package READMEs
5. **File an issue**: [GitHub Issues](https://github.com/asifmomin/dotfiles/issues)

---

**Can't find your question?** [Open an issue](https://github.com/asifmomin/dotfiles/issues/new) and we'll add it to the FAQ!
