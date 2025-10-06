# Philosophy & Design Principles

This dotfiles configuration follows a minimal, practical approach to development environment management.

## Core Principles

### 1. Simplicity Over Complexity
- Prefer tool defaults over extensive customization
- Use proven solutions rather than custom implementations
- Keep configurations minimal and maintainable
- Trust upstream projects (LazyVim, Starship, etc.)

### 2. Cross-Platform Consistency
- Identical experience on macOS, Linux, and WSL
- Single package manager (Homebrew) for all platforms
- Platform-specific code only when necessary
- Automated platform detection

### 3. Security Built-In
- Encrypted secrets management (SOPS + age)
- No plaintext secrets in version control
- Proper file permissions by default
- Secure key generation and storage

### 4. Modern Standards
- XDG Base Directory compliance
- Clean config organization in `~/.config/`
- Separation of config, data, and cache
- Modern CLI tools (eza, bat, ripgrep, fd, etc.)

## Design Decisions

### Package Management
**Homebrew for all platforms** - Provides consistent package availability and management across macOS, Linux, and WSL.

### Configuration Management
**GNU Stow** - Simple, clean symlink management. Each tool gets its own package that can be applied or removed atomically.

### Secrets Management
**SOPS + age** - Modern alternative to GPG. Simple key management, file-based encryption, team-friendly.

### Theme System
**Tokyo Night** - Professional dark theme with excellent readability. Applied consistently across all tools for a unified visual experience.

### Editor Philosophy
**LazyVim-based Neovim** - Minimal configuration that trusts LazyVim defaults. Only 4 config files total.

## Quality Standards

### Tool Selection Criteria
- **Wide adoption** - Used by significant portion of developers
- **Cross-platform** - Available on macOS, Linux, WSL
- **Active maintenance** - Regularly updated
- **Terminal-based** - Works in terminal environment
- **Performance** - Doesn't slow down startup time

### Code Quality
- Shell scripts use `set -euo pipefail`
- All variables properly quoted
- ShellCheck compliance
- Clear documentation

## Non-Goals

This system intentionally does NOT aim to:
- Provide complete desktop environment configuration
- Include every possible development tool
- Support GUI application configurations
- Manage system administration tasks
- Include language-specific IDEs

Focus remains on terminal-based development tools and workflows.

## Evolution Strategy

**Conservative approach:**
- Stability over novelty
- Backwards compatibility within major versions
- Community input for major changes
- Regular maintenance over feature creep

**Sustainable development:**
- Clear documentation for all features
- Examples that work out of the box
- Migration guides for breaking changes
- Regular review of included tools
