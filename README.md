# Dotfiles

> Modern, cross-platform development environment with Tokyo Night theme and minimal design

**Inspired by [Omarchy](https://github.com/basecamp/omarchy)** - Extending its minimal philosophy with modern development workflows.

## Quick Start

```bash
# One-liner bootstrap (installs everything)
curl -fsSL https://raw.githubusercontent.com/asifmomin/dotfiles/main/bootstrap.sh | bash

# OR manual installation
git clone https://github.com/asifmomin/dotfiles.git ~/dotfiles
cd ~/dotfiles
just bootstrap

# After bootstrap completes, close and restart your shell for changes to take effect
```

## Features

- 🎨 **Tokyo Night theme** - Consistent colors across all applications
- 📦 **Stow-managed** - Clean symlink management with XDG-first approach  
- 🍺 **Homebrew** - Cross-platform package management
- 🔒 **SOPS + age** - Modern encrypted secrets management
- ⚡ **Just** - Single command interface for all operations
- 🖥️ **Cross-platform** - Works on macOS, Linux, and WSL
- 🎯 **Omarchy-inspired** - Minimal, focused, and performant
- 🔧 **Modern tooling** - Latest CLI tools and development workflows

## What's Included

### Development Environment
- **Neovim** - LazyVim configuration following Omarchy's minimal approach
- **Git** - Directory-based identity switching (work/personal) + Tokyo Night colors
- **Tmux** - Terminal multiplexer with Tokyo Night theme and vim-like bindings
- **mise** - Runtime version manager with Python 3.12 LTS and Node.js LTS pre-installed
- **Direnv** - Per-directory environment management for projects
- **Colima + Docker** - Lightweight container runtime without Docker Desktop

### Modern CLI Tools
- **Bat** - Syntax-highlighted file viewer with Tokyo Night theme
- **Btop** - System monitor with custom Tokyo Night theme
- **Eza** - Modern ls replacement (via shell aliases)
- **Fd** - Fast find alternative (via shell aliases)
- **Ripgrep** - Fast text search (via shell aliases)
- **Fzf** - Fuzzy finder with Tokyo Night colors
- **Zoxide** - Smart cd replacement (via shell functions)
- **Glow** - Terminal markdown renderer with syntax highlighting
- **git-delta** - Better git diff with syntax highlighting and side-by-side view
- **lazygit** - Terminal UI for git with Tokyo Night theme integration

### Advanced Features
- **SOPS + age** - Encrypted secrets management for API keys and credentials
- **Tokyo Night theme** - Unified color palette across all applications
- **XDG compliance** - Clean config organization in ~/.config/
- **Cross-platform** - Works identically on macOS, Linux, and WSL

## Commands

### Setup & Installation
```bash
just bootstrap        # Full setup: packages, stow, secrets
just doctor          # Health check all tools
just install-packages # Install packages via Homebrew
```

### Configuration Management
```bash
just stow-check      # Preview stow operations (dry run)
just stow-apply      # Apply all configuration packages
just stow-remove     # Remove all configuration packages
just stow-restow     # Remove and reapply packages
```

### Secrets Management
```bash
just secrets-init    # Generate age keys and configure SOPS
just secrets-edit f= # Edit encrypted file (e.g., secrets/env/github.sops.yaml)
just secrets-show f= # Show decrypted content
just secrets-apply   # Decrypt all secrets to ~/.local/share/secrets/
```

### Maintenance
```bash
just update          # Update packages and sync dotfiles
just clean           # Remove broken symlinks
just status          # Show dotfiles status and info
just edit            # Open dotfiles directory in editor
```

## Shell Shortcuts & Aliases

Commonly used shortcuts (full list in [Shell Aliases Reference](./packages/shell/ALIASES.md)):

### Navigation
```bash
ls / lsa            # Enhanced listing with eza (icons, git status)
lt / lta            # Tree view (2 levels deep)
.. / ... / ....     # Navigate up 1/2/3 directories
-                   # Go to previous directory
```

### File Operations
```bash
cat                 # Syntax-highlighted viewing with bat
find                # Fast file search with fd
grep                # Fast text search with ripgrep
ff                  # Fuzzy finder with preview
```

### Git Workflow
```bash
g                   # git
gst                 # git status
ga / gaa            # git add / git add .
gcm "msg"           # git commit -m "msg"
gp / gpl            # git push / git pull
gl                  # git log (formatted)
gd                  # git diff
```

### Docker
```bash
d / dc              # docker / docker-compose
dps / dpsa          # docker ps / docker ps -a
dlog                # docker logs -f
```

### System Monitoring
```bash
top                 # btop (modern system monitor)
du                  # dust (disk usage)
```

### Homebrew
```bash
brewup              # brew update && brew upgrade
brewi / brews       # brew install / brew search
```

**See [Complete Aliases Reference](./packages/shell/ALIASES.md)** for all 60+ shortcuts and platform-specific commands.

## Quick Reference

### Essential Commands
```bash
just bootstrap        # Initial setup (first time only)
just doctor          # Health check all tools
just stow-apply      # Apply configurations
just update          # Update packages and dotfiles
```

### Common Workflows

**Git Identity Switching**
```bash
# Setup once
mkdir -p ~/work ~/per
git config --file ~/.config/git/config-work user.email "work@company.com"
git config --file ~/.config/git/config-personal user.email "personal@email.com"

# Use automatically
cd ~/work/my-project   # Uses work identity
cd ~/per/side-project  # Uses personal identity
```

**Runtime Version Management (mise)**
```bash
# In your project directory
echo "node 20.10.0" > .tool-versions
echo "python 3.12.0" >> .tool-versions

# Versions auto-switch when you cd into directory
```

**Secrets Management**
```bash
just secrets-init                           # Generate encryption keys
just secrets-edit f=secrets/env/api.sops.yaml  # Create encrypted secret
just secrets-apply                          # Decrypt for use
```

**Quick Links**
- [Quick Start Guide](./docs/QUICKSTART.md) - Get running in 5 minutes
- [Shell Customization](./packages/shell/README.md#customization)
- [FAQ](./docs/FAQ.md) - Common questions

## Platform Support

- **macOS**: Full support via Homebrew
- **Linux**: Full support via Homebrew  
- **WSL**: Full support via Homebrew
- **Requirements**: git, curl (usually pre-installed)

## Documentation

**Getting Started:**
- [Quick Start Guide](./docs/QUICKSTART.md) - Get running in 5 minutes
- [Installation Instructions](./docs/instructions.md) - Detailed setup guide
- [FAQ](./docs/FAQ.md) - Common questions and troubleshooting

**Configuration:**
- [Git Directory Switching](./docs/git-directory-switching.md) - Automatic work/personal identity
- [Shell Aliases Reference](./packages/shell/ALIASES.md) - All 60+ shortcuts
- [Shell Functions](./packages/shell/README.md) - Custom shell functions
- [macOS-Specific Packages](./docs/MACOS-PACKAGES.md) - GUI apps and GNU utilities

**About:**
- [Philosophy & Design Principles](./docs/PHILOSOPHY.md) - Design decisions
- [Credits & Inspiration](./docs/CREDITS.md) - Omarchy and tools used

## License

MIT - see [LICENSE](./LICENSE)