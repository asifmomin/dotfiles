# Lazygit Configuration

Terminal UI for git commands with Tokyo Night theme integration.

## Features

- **Tokyo Night Theme**: Consistent colors with other dotfiles
- **Delta Integration**: Uses delta for better diffs
- **Neovim Integration**: Opens in Neovim via `<leader>gg`
- **Auto-fetch**: Automatically fetches from remote every 60 seconds
- **Mouse Support**: Click to navigate (optional)

## Configuration

- **Config**: `~/.config/lazygit/config.yml`
- **Theme**: Tokyo Night colors matching terminal and editor
- **Editor**: Uses Neovim for commit messages and file editing

## Keyboard Shortcuts

See main documentation or press `?` inside lazygit for context-sensitive help.

### Quick Reference
- `space` - Stage/unstage files
- `c` - Commit
- `P` - Push
- `p` - Pull
- `?` - Help
- `q` - Quit

## Usage in Neovim

In LazyVim:
- `<leader>gg` - Open lazygit
- `<leader>gf` - Open lazygit for current file

## Dependencies

- lazygit (installed via Homebrew)
- delta (optional, for better diffs)
- Neovim (for git editor)
