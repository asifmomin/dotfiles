# Eza Package

Modern `ls` replacement with colors, icons, and git integration.

## What's Included

- **Tokyo Night Theme**: Custom color scheme for eza matching the overall Tokyo Night theme
- **Proper icon/color rendering**: Fixes icon display and date visibility issues

## Configuration

- `~/.config/eza/theme.yml`: Tokyo Night color scheme for eza

## Installation

Installed via Homebrew (see `platform/brew/Brewfile`).

Applied via stow:
```bash
just stow-apply
```

## Usage

The shell aliases (defined in `packages/shell/.config/zsh/aliases.zsh`) use eza:
- `ls` - eza with icons and colors
- `lsa` - show all files
- `lt` - tree view
- `lta` - tree view with all files

## Theme

Colors are from the Omarchy Tokyo Night theme to ensure:
- Proper icon visibility
- Readable date colors
- Consistent git status indicators
- Proper permission color coding
