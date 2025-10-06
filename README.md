# Dotfiles

> Modern, cross-platform development environment with Tokyo Night theme and Omarchy-inspired minimal design

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
- **Direnv** - Directory-based environment management for projects

### Modern CLI Tools
- **Bat** - Syntax-highlighted file viewer with Tokyo Night theme
- **Btop** - System monitor with custom Tokyo Night theme
- **Eza** - Modern ls replacement (via shell aliases)
- **Fd** - Fast find alternative (via shell aliases)
- **Ripgrep** - Fast text search (via shell aliases)
- **Fzf** - Fuzzy finder with Tokyo Night colors
- **Zoxide** - Smart cd replacement (via shell functions)
- **Glow** - Terminal markdown renderer with syntax highlighting

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

## Platform Support

- **macOS**: Full support via Homebrew
- **Linux**: Full support via Homebrew  
- **WSL**: Full support via Homebrew
- **Requirements**: git, curl (usually pre-installed)

## Documentation

See [docs/](./docs/) for detailed documentation:
- [Installation Instructions](./docs/instructions.md)
- [Philosophy & Design Principles](./docs/PHILOSOPHY.md)
- [Git Directory Switching](./docs/git-directory-switching.md)
- [Credits & Inspiration](./docs/CREDITS.md)

## License

MIT - see [LICENSE](./LICENSE)