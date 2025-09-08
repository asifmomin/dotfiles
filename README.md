# Dotfiles (Stow + just + sops/age, XDG-first)

> Modern, cross-platform dotfiles with Tokyo Night theme

## Quick start
```sh
# One-liner bootstrap (installs everything)
curl -fsSL https://raw.githubusercontent.com/asifmomin/dotfiles/main/bootstrap.sh | bash

# OR manual installation
git clone https://github.com/asifmomin/dotfiles.git ~/dotfiles
cd ~/dotfiles
just bootstrap
```

## Features

- 🎨 **Tokyo Night theme** across all tools
- 📦 **Stow-managed** symlinks with XDG-first approach  
- 🍺 **Homebrew** for cross-platform package management
- 🔒 **sops + age** for encrypted secrets
- ⚡ **just** as single command interface
- 🖥️ **Cross-platform** (macOS, Linux, WSL)

## Included Tools

### Shell & Terminal
- **Alacritty** (terminal with Tokyo Night)
- **Zsh** with modern configuration  
- **Starship** (cross-shell prompt)
- **Tmux** (terminal multiplexer)

### Modern CLI
- **eza** (better ls), **bat** (better cat)
- **fd** (better find), **ripgrep** (better grep) 
- **fzf** (fuzzy finder), **zoxide** (smart cd)
- **btop** (system monitor)

### Development
- **Neovim** with LazyVim + Tokyo Night
- **Git** with custom aliases
- **GitHub CLI**, **Lazygit**
- **Mise** (runtime manager)
- **Direnv** (per-directory environments)

## Available Commands

```sh
just bootstrap        # Full setup: brew, packages, stow, secrets init
just doctor          # Health check all tools
just stow-check      # Dry run stow operations  
just stow-apply      # Apply all stow packages
just stow-remove     # Remove all stow packages
just secrets:init    # Generate age keys, show public key
just secrets:edit f=path/to/file.sops.yaml
just secrets:apply   # Decrypt and apply secrets
just update         # Update packages and sync dotfiles
```

## Platform Support

- **macOS**: Full support via Homebrew
- **Linux**: Full support via Homebrew  
- **WSL**: Full support via Homebrew
- **Requirements**: git, curl (usually pre-installed)

## Documentation

See [docs/](./docs/) for detailed documentation:
- [Installation Instructions](./docs/instructions.md)
- [Goals & Philosophy](./docs/goals.md)
- [Workspace Context](./docs/workspace-context.md)
- [Guardrails](./docs/guardrails.md)

## License

MIT - see [LICENSE](./LICENSE)