# Tmux Configuration

Minimal tmux configuration with Tokyo Night theme and XDG compliance.

## Features

- **Tokyo Night theme** with consistent colors
- **XDG-compliant** configuration structure
- **Vim-like keybindings** for pane navigation
- **Modern defaults** with mouse support
- **Minimal philosophy** following Omarchy approach

## Installation

```bash
# Apply configuration via stow
cd ~/dotfiles
just stow-apply

# Or manually
stow -d packages -t ~ tmux
```

## Structure

```
tmux/
├── .tmux.conf              # Legacy shim (sources XDG config)
└── .config/
    └── tmux/
        └── tmux.conf       # Main configuration
```

## Key Bindings

### Prefix Key: `Ctrl-a`

#### Session Management
- `Ctrl-a r` - Reload tmux configuration
- `Ctrl-a d` - Detach from session

#### Window Management
- `Ctrl-a c` - Create new window (in current directory)
- `Ctrl-a ,` - Rename window
- `Ctrl-a n` - Next window
- `Ctrl-a p` - Previous window
- `Ctrl-a 1-9` - Switch to window by number

#### Pane Management
- `Ctrl-a |` - Split horizontally (in current directory)
- `Ctrl-a -` - Split vertically (in current directory)
- `Ctrl-a h/j/k/l` - Navigate panes (vim-like)
- `Ctrl-a H/J/K/L` - Resize panes
- `Ctrl-a x` - Close pane

#### Copy Mode
- `Ctrl-a Enter` - Enter copy mode
- `v` - Begin selection (in copy mode)
- `y` - Copy selection (in copy mode)
- `Escape` - Exit copy mode

## Tokyo Night Theme

### Color Palette
- Background: `#1a1b26` (dark blue-black)
- Foreground: `#a9b1d6` (light blue-gray)
- Active: `#7aa2f7` (bright blue)
- Accent: `#9ece6a` (mint green)
- Warning: `#e0af68` (warm yellow)

### Status Bar
- **Left**: Session name with green background
- **Right**: Hostname and current time
- **Windows**: Current window highlighted in blue
- **Separators**: Clean powerline-style separators

## Configuration Details

### Terminal Settings
- 256-color support with true color
- Mouse support enabled
- Large scrollback history (10,000 lines)
- Windows and panes start at index 1

### Behavior
- Automatic window renumbering
- New windows/panes open in current directory
- Vi-mode key bindings in copy mode
- Quick config reload with `Ctrl-a r`

## Integration with Other Tools

### Shell Integration
Works seamlessly with the zsh configuration:
- Respects current working directory
- Integrates with starship prompt
- Compatible with modern CLI tools

### Editor Integration
- Vi-mode copy/paste
- Proper color support for Neovim
- Terminal compatibility for LazyVim

### System Clipboard
- Copy selections automatically go to system clipboard
- Works with pbcopy on macOS and xclip on Linux

## Customization

### Personal Overrides
Add personal customizations to `~/.config/tmux/local.conf`:

```bash
# ~/.config/tmux/local.conf
bind-key M-j resize-pane -D
bind-key M-k resize-pane -U
bind-key M-h resize-pane -L
bind-key M-l resize-pane -R
```

Then source it in the main config:
```bash
# Add to tmux.conf
source-file ~/.config/tmux/local.conf
```

### Plugin Support
To add tmux plugins, install TPM:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then add to config:
```bash
# Plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Initialize TPM (keep at bottom)
run '~/.config/tmux/plugins/tpm/tpm'
```

## Common Commands

### Session Management
```bash
# Start new session
tmux new -s work

# Attach to session
tmux attach -t work

# List sessions
tmux list-sessions

# Kill session
tmux kill-session -t work
```

### Window Management
```bash
# Create window with name
tmux new-window -n editor

# Move window
tmux move-window -t 3
```

## Troubleshooting

### Colors Not Working
Ensure your terminal supports 256 colors:
```bash
echo $TERM  # Should be screen-256color or similar
```

### Key Bindings Not Working
Check if prefix key is properly set:
```bash
tmux show-options -g prefix
```

### Config Not Loading
Verify config file location:
```bash
ls -la ~/.config/tmux/tmux.conf
```

## Resources

- [Tmux Manual](https://github.com/tmux/tmux/wiki)
- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme)
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)