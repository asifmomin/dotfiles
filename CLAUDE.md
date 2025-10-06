# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modern, cross-platform dotfiles repository built with stow, just, and SOPS/age. It follows Omarchy's minimal philosophy while providing a complete development environment with Tokyo Night theming across all tools.

**Key Technologies:**
- **Package Management:** Homebrew (macOS, Linux, WSL)
- **Config Management:** GNU Stow for symlink management
- **Command Runner:** Just (alternative to make)
- **Secrets:** SOPS with age encryption
- **Theme:** Tokyo Night (unified across all tools)

**Core Principles:**
- Omarchy-inspired minimalism (trust defaults, essential features only)
- XDG-first approach (configs in `~/.config/`)
- Cross-platform compatibility (identical behavior on macOS/Linux/WSL)
- Security built-in (SOPS + age for encrypted secrets)

## Essential Commands

### Bootstrap & Installation
```bash
# Full bootstrap (run this first on new systems)
just bootstrap

# Health check all tools
just doctor

# Install packages only
just install-packages
```

### Configuration Management
```bash
# Preview stow operations (dry run - use this before applying)
just stow-check

# Apply all stow packages
just stow-apply

# Remove all stow packages
just stow-remove

# Restow (remove + reapply)
just stow-restow
```

### Secrets Management
```bash
# Initialize secrets (generates age keys)
just secrets-init

# Edit encrypted file
just secrets-edit f=secrets/env/github.sops.yaml

# Show decrypted content
just secrets-show f=secrets/env/github.sops.yaml

# Apply/decrypt all secrets
just secrets-apply
```

### Maintenance
```bash
# Update packages and dotfiles
just update

# Clean broken symlinks
just clean

# Show dotfiles status
just status

# Open dotfiles in editor
just edit
```

## Architecture & Structure

### Repository Layout
```
dotfiles/
├── packages/          # Stow packages (one dir per tool)
│   ├── shell/        # Zsh config with XDG structure
│   ├── git/          # Git config with directory-based identity switching
│   ├── neovim/       # LazyVim minimal config
│   ├── tmux/         # Tmux with Tokyo Night theme
│   ├── alacritty/    # Terminal emulator config
│   ├── bat/          # Syntax-highlighted cat replacement
│   ├── btop/         # System monitor with custom theme
│   └── direnv/       # Per-directory environment management
│
├── lib/              # Helper libraries
│   ├── platform.sh   # Platform detection utilities
│   └── scripts/      # Core scripts
│       ├── doctor.sh           # Health check
│       ├── stow-*.sh           # Stow management
│       ├── secrets.sh          # Secrets operations
│       ├── secrets-apply.sh    # Apply decrypted secrets
│       └── setup-shell.sh      # Shell setup
│
├── platform/         # Platform-specific configs
│   └── brew/
│       └── Brewfile  # All package definitions
│
├── themes/           # Theme definitions
│   └── tokyo-night/
│       ├── colors.sh # Unified color palette
│       └── README.md # Theme documentation
│
├── secrets/          # Encrypted secrets (SOPS + age)
│   ├── examples/     # Example secret files
│   ├── env/          # Environment variable secrets
│   └── ssh/          # SSH config secrets
│
├── docs/             # Documentation
│   ├── workspace-context.md  # Architecture decisions
│   └── guardrails.md         # Design constraints
│
├── justfile          # Command definitions
├── bootstrap.sh      # One-liner bootstrap script
└── .sops.yaml        # SOPS configuration
```

### Stow Package Structure

Each package in `packages/` follows XDG structure:
```
packages/<tool>/
├── .config/<tool>/   # XDG config (preferred)
├── .<tool>rc         # Legacy shim (if needed)
└── README.md         # Package documentation
```

When stowed, files are symlinked to `$HOME`, preserving directory structure.

### Platform Detection

Use `lib/platform.sh` for cross-platform logic:
```bash
source lib/platform.sh

if is_macos; then
    # macOS-specific
elif is_linux; then
    # Linux-specific
elif is_wsl; then
    # WSL-specific
fi
```

Homebrew paths differ by platform:
- macOS: `/opt/homebrew`
- Linux/WSL: `/home/linuxbrew/.linuxbrew` or `$HOME/.linuxbrew`

## Key Architectural Patterns

### 1. Git Directory-Based Identity Switching

Git configuration supports automatic identity switching by directory:
- `~/work/*` → Uses `~/.config/git/config-work`
- `~/per/*` → Uses `~/.config/git/config-personal`
- Other directories → Uses global config

Setup work identity:
```bash
mkdir -p ~/work
git config --file ~/.config/git/config-work user.name "Work Name"
git config --file ~/.config/git/config-work user.email "work@company.com"
```

### 2. Secrets Management with SOPS + Age

Secrets are encrypted with age (modern GPG alternative):

1. Initialize (generates age keypair):
   ```bash
   just secrets-init
   ```

2. Create encrypted secret:
   ```bash
   just secrets-edit f=secrets/env/myservice.sops.yaml
   ```

3. File naming pattern: `secrets/{category}/{name}.sops.yaml`

Age key location: `~/.config/age/key.txt` (private key, never commit)

### 3. Tokyo Night Theme System

Unified color palette in `themes/tokyo-night/colors.sh`:
- Applied across: shell (starship), git, tmux, neovim, bat, btop, alacritty
- Consistent visual experience across all tools
- Colors defined once, referenced everywhere

### 4. Shell Configuration (Zsh)

XDG-compliant structure:
```
packages/shell/
├── .zshrc                      # Legacy shim (sources XDG config)
└── .config/
    ├── zsh/
    │   ├── .zshrc              # Main config
    │   ├── aliases.zsh         # Aliases (eza, bat, fd, rg, etc.)
    │   ├── functions.zsh       # Shell functions
    │   └── local.zsh.example   # User overrides template
    └── starship.toml           # Prompt config
```

Real config is in `~/.config/zsh/.zshrc`, loaded by legacy `~/.zshrc` shim.

### 5. Neovim Configuration

Ultra-minimal LazyVim setup (Omarchy-inspired):
- Only 4 files total
- Trust LazyVim defaults completely
- Tokyo Night theme only
- Comprehensive transparency
- No animations (performance)

Located in `packages/neovim/.config/nvim/`

## Important Conventions

### Script Standards
All shell scripts MUST:
- Use `set -euo pipefail` for error handling
- Quote all variables
- Include error checking
- Follow ShellCheck recommendations

### Git Commit Messages
When creating commits:
- Write clear, concise commit messages
- DO NOT add "🤖 Generated with Claude Code" attribution
- DO NOT add "Co-Authored-By: Claude <noreply@anthropic.com>"
- Follow conventional commit style when appropriate
- Focus commit message on the "why" and "what" of changes

### Stow Operations
Before ANY stow changes:
1. Run `just stow-check` to preview
2. Review conflicts/warnings
3. Then run `just stow-apply`

Never force stow without checking first.

### Adding New Tools

Must meet ALL criteria:
- Cross-platform (available via Homebrew on macOS/Linux/WSL)
- Actively maintained
- Wide adoption (not niche)
- Doesn't slow startup
- Aligns with Omarchy philosophy (minimal, essential)

Process:
1. Add to `platform/brew/Brewfile`
2. Create package in `packages/<tool>/` with XDG structure
3. Apply Tokyo Night theme if applicable
4. Add justfile command if needed
5. Update doctor.sh health check
6. Test on all platforms

### Secrets Workflow

NEVER commit plaintext secrets. Always:
1. Create encrypted file: `just secrets-edit f=secrets/env/file.sops.yaml`
2. Edit in your editor (SOPS handles encryption)
3. Commit the `.sops.yaml` file (encrypted)

To use secrets:
```bash
just secrets-apply  # Decrypts to ~/.local/share/secrets/
```

### Breaking Changes

If modifying core files that may break existing setups:
1. Test on clean VM/container
2. Update documentation
3. Provide migration guide
4. Consider backup mechanism

## Testing & Validation

### Before Committing

1. Run health check:
   ```bash
   just doctor
   ```

2. Verify stow operations:
   ```bash
   just stow-check
   ```

3. Test on target platform (macOS/Linux/WSL)

### Bootstrap Testing

Test bootstrap on clean system:
```bash
curl -fsSL https://raw.githubusercontent.com/asifmomin/dotfiles/main/bootstrap.sh | bash
```

Should complete without errors and create all expected symlinks.

## Common Development Tasks

### Modifying Stow Packages

1. Edit files in `packages/<tool>/`
2. Run `just stow-restow` to reapply
3. Test the affected tool
4. Commit changes

### Adding Homebrew Packages

1. Add to `platform/brew/Brewfile`
2. Use platform conditionals if needed:
   ```ruby
   brew "package" unless OS.mac?  # Linux/WSL only
   if OS.mac?
     brew "macos-only-package"
   end
   ```
3. Run `just install-packages`
4. Add to `lib/scripts/doctor.sh` health check

### Updating Shell Configuration

1. Edit `packages/shell/.config/zsh/.zshrc` (NOT `~/.zshrc`)
2. Run `just stow-restow`
3. Test: `exec zsh` or restart terminal
4. Verify changes persist

### Working with Secrets

Always use justfile commands:
```bash
# Edit (creates if doesn't exist)
just secrets-edit f=secrets/env/newfile.sops.yaml

# View decrypted
just secrets-show f=secrets/env/newfile.sops.yaml

# Apply all
just secrets-apply
```

Public key in `.sops.yaml` must match your age key (`~/.config/age/key.txt`).

## Platform-Specific Considerations

### macOS
- Homebrew prefix: `/opt/homebrew`
- Includes GNU coreutils for compatibility
- Native zsh (macOS 10.15+)

### Linux
- Homebrew prefix: `/home/linuxbrew/.linuxbrew` or `$HOME/.linuxbrew`
- Requires build-essential for compilation
- Installs zsh via Homebrew

### WSL
- Detected as Linux with Microsoft in `/proc/version`
- Same as Linux but with Windows integration
- May need xclip for clipboard operations

## Design Constraints (from Guardrails)

**Respect these when making changes:**

1. **Omarchy Philosophy** - Minimal, trust defaults, essential features only
2. **Cross-Platform** - Must work identically on macOS/Linux/WSL
3. **Security** - No plaintext secrets, proper file permissions
4. **Minimal Config** - Justify every customization, prefer upstream defaults
5. **Performance** - Shell startup < 200ms, no slow tools in critical path

**Avoid:**
- Complex custom configurations (especially Neovim)
- GUI-only or language-specific tools
- Features that duplicate existing tool functionality
- Breaking changes without migration guides

## Troubleshooting

### Stow Conflicts
```bash
# Check what's conflicting
just stow-check

# Remove and reapply
just stow-restow
```

### Homebrew Issues
```bash
# Ensure Homebrew in PATH
eval "$(brew shellenv)"

# Reinstall packages
brew bundle --file=platform/brew/Brewfile
```

### Secrets Decryption Fails
```bash
# Verify age key exists
ls ~/.config/age/key.txt

# Check permissions
chmod 600 ~/.config/age/key.txt

# Test manually
sops -d secrets/env/file.sops.yaml
```

### Shell Not Updating
```bash
# Ensure using XDG config
cat ~/.zshrc  # Should source .config/zsh/.zshrc

# Reapply shell package
just stow-restow
exec zsh
```

## Additional Resources

- **Documentation:** See `docs/` directory
  - `PHILOSOPHY.md` - Design principles and philosophy
  - `instructions.md` - Installation and setup guide
  - `git-directory-switching.md` - Git identity switching setup
  - `CREDITS.md` - Credits and tool acknowledgments
- **Package READMEs:** Each package has detailed documentation
- **Omarchy Reference:** https://github.com/basecamp/omarchy
- **Tokyo Night Theme:** https://github.com/enkia/tokyo-night-vscode-theme
