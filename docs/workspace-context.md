# Workspace Context

This document provides context about the dotfiles repository architecture, implementation decisions, and integration with the broader development ecosystem.

## Repository Overview

This dotfiles repository is a modern, cross-platform development environment configuration system built with the following core principles:

### Design Philosophy

1. **Omarchy-Inspired Minimalism**
   - Extract and adapt the best components from [Omarchy](https://github.com/2KAbhishek/omarchy)
   - Maintain minimal, focused configurations
   - Trust proven defaults while adding essential functionality
   - Prefer simple solutions over complex ones

2. **XDG-First Approach**
   - Configurations stored in `~/.config/<tool>/` when possible
   - Legacy shims only when required for compatibility
   - Clean separation of config, data, and cache directories
   - Respect XDG Base Directory specification

3. **Stow-Managed Symlinks**
   - GNU Stow for clean symlink management
   - Package-based organization for modularity
   - Easy addition/removal of configuration packages
   - No complex installation scripts

4. **Modern Security**
   - SOPS + age for encrypted secrets management
   - No plaintext secrets in version control
   - Secure by default with proper file permissions
   - Team-friendly secret sharing capabilities

## Architecture Decisions

### Package Management Strategy

**Decision**: Use Homebrew for all platforms (macOS, Linux, WSL)
**Rationale**: 
- Consistent package management across platforms
- Excellent package availability and maintenance
- Reliable formula ecosystem
- Better than mixing apt/yum/pacman across systems

**Implementation**: Single `Brewfile` with platform-specific conditionals

### Configuration Management

**Decision**: Stow-based symlink farm with XDG compliance
**Rationale**:
- Clean separation of dotfiles from home directory
- Easy to understand and maintain
- Atomic package application/removal
- Version control friendly

**Implementation**: 
- `packages/` directory with stow packages
- Each package follows XDG structure where possible
- Legacy shims for tools that don't support XDG

### Secret Management

**Decision**: SOPS with age encryption
**Rationale**:
- Modern alternative to GPG (no key servers, simpler setup)
- File-based encryption (no external dependencies)
- Team collaboration friendly
- Integrates well with version control

**Implementation**:
- `.sops.yaml` configuration with age recipient
- `secrets/` directory with example templates
- Justfile commands for common operations

### Theme System

**Decision**: Tokyo Night theme across all applications
**Rationale**:
- Professional, dark theme suitable for development
- Excellent readability and contrast
- Available for most development tools
- Consistent visual experience

**Implementation**:
- Unified color palette in `themes/tokyo-night/colors.sh`
- Application-specific color mappings
- Theme switching utilities where applicable

## Component Integration

### Shell Environment (Zsh)

**Base**: Omarchy's bash configuration adapted to Zsh
**Enhancements**:
- XDG compliance with config in `~/.config/zsh/`
- Modern CLI tool integration (eza, bat, fzf, etc.)
- Starship prompt with Tokyo Night colors
- Function library extracted from Omarchy

**Integration Points**:
- Direnv for project-specific environments
- Git aliases for version control workflow
- FZF with Tokyo Night colors for fuzzy finding
- Zoxide for smart directory navigation

### Editor Configuration (Neovim)

**Base**: LazyVim distribution
**Philosophy**: Follow Omarchy's minimal approach
**Implementation**:
- Ultra-minimal config (4 files total like Omarchy)
- Tokyo Night theme only
- Comprehensive transparency like Omarchy
- Disabled animations for performance
- Trust LazyVim defaults completely

**Integration Points**:
- Git integration with proper colors
- Terminal integration with consistent theme
- Shell integration for external commands

### Terminal Multiplexer (Tmux)

**Base**: Custom configuration (Omarchy doesn't include tmux)
**Design**: Minimal but functional
**Implementation**:
- Tokyo Night theme for status line
- Vim-like key bindings
- Modern defaults (mouse support, 256-color)
- XDG compliance with legacy shim

**Integration Points**:
- Shell environment preserved across sessions
- Consistent theme with terminal and editor
- Proper color support for all tools

### Version Control (Git)

**Base**: Standard Git configuration
**Enhancement**: Directory-based identity switching
**Implementation**:
- Conditional includes for work/personal directories
- Tokyo Night colors for diff and status output
- Comprehensive aliases adapted from Omarchy
- XDG compliance with legacy shim

**Integration Points**:
- Shell aliases for common operations
- Starship prompt for git status display
- Proper editor integration with Neovim

## Platform Considerations

### Cross-Platform Compatibility

**macOS**:
- Native Homebrew support
- Full feature compatibility
- macOS-specific aliases and functions

**Linux**:
- Homebrew on Linux
- Distribution-agnostic approach
- Linux-specific aliases (pbcopy/pbpaste via xclip)

**WSL (Windows Subsystem for Linux)**:
- Homebrew on WSL
- Windows integration aliases
- Proper path handling

### Tool Dependencies

**Required Tools**:
- Git (usually pre-installed)
- Curl (usually pre-installed)
- Homebrew (installed by bootstrap script)

**Managed Dependencies**:
- All other tools installed via Homebrew
- Version consistency across platforms
- Automatic dependency resolution

## Development Workflow Integration

### Project-Based Environment

**Direnv Integration**:
- Automatic environment switching per directory
- Runtime version management via mise
- Database connection configuration
- Secrets loading from encrypted files

**Git Workflow**:
- Directory-based identity (work vs personal)
- Consistent aliases and shortcuts
- Proper SSH key management
- Tokyo Night themed output

### Modern CLI Integration

**File Management**:
- `eza` for enhanced directory listings
- `bat` for syntax-highlighted file viewing
- `fd` for fast file finding
- `ripgrep` for fast text search

**Navigation**:
- `zoxide` for smart directory jumping
- `fzf` for fuzzy finding everything
- Directory-based git status in prompt

### System Monitoring

**Development Tools**:
- `btop` for system resource monitoring
- Tokyo Night themed output
- Integration with terminal theme

## Security Model

### Secrets Management

**Encryption**: Age-based symmetric encryption
**Storage**: Encrypted files in `secrets/` directory
**Access**: Local age key in `~/.config/age/key.txt`
**Sharing**: Public key sharing for team access

**Security Measures**:
- Gitignore rules prevent accidental commits
- Proper file permissions (600) on private keys
- Example files use placeholder data only
- Decrypted secrets stored in temporary locations

### Access Control

**File Permissions**: Proper Unix permissions on sensitive files
**Git Integration**: No secrets in git history
**Team Access**: SOPS allows multiple recipients
**Audit Trail**: Git history shows configuration changes

## Maintenance Strategy

### Updates and Upgrades

**Package Updates**: `just update` handles all package updates
**Configuration Updates**: Git pull for dotfiles updates
**Security Updates**: Regular age key rotation recommendations

**Testing**: Health check via `just doctor`
**Validation**: Dry run via `just stow-check`
**Recovery**: Easy rollback via git and stow

### Documentation Maintenance

**Living Documentation**: Documentation updated with code changes
**Examples**: Working examples for all major features
**Troubleshooting**: Common issues and solutions documented
**Integration**: Cross-references between components

## Future Considerations

### Extensibility

**New Tools**: Easy addition via new stow packages
**Customization**: Local overrides via `local.zsh` and similar
**Team Variations**: Fork-friendly architecture
**Platform Extensions**: Easy addition of new platform support

### Performance

**Startup Time**: Minimal shell startup overhead
**Resource Usage**: Lightweight tool selection
**Caching**: Intelligent caching where beneficial
**Lazy Loading**: Tools load only when needed

This workspace context provides the foundation for understanding how all components work together to create a cohesive, modern development environment while maintaining the simplicity and focus that makes Omarchy effective.