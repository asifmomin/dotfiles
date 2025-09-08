# Alacritty Terminal Configuration

GPU-accelerated terminal emulator with Tokyo Night theme.

## Features

- **Tokyo Night theme** with three variants (default, storm, light)
- **CaskaydiaMono Nerd Font** for programming ligatures and icons
- **Optimized settings** for performance and readability
- **Cross-platform** configuration (macOS, Linux, WSL)
- **Custom keybindings** for productivity

## Installation

```bash
# Apply configuration via stow
cd ~/dotfiles
just stow-apply

# Or manually
stow -d packages -t ~ alacritty
```

## Configuration

Main config: `~/.config/alacritty/alacritty.toml`

### Theme Switching

To switch themes, edit the main config and add an import:

```toml
# Add this line at the top of alacritty.toml
general.import = [ "~/.config/alacritty/themes/tokyo-night-storm.toml" ]
```

Available themes:
- `tokyo-night.toml` - Default Tokyo Night
- `tokyo-night-storm.toml` - Darker variant
- `tokyo-night-light.toml` - Light variant

### Font Settings

Default: CaskaydiaMono Nerd Font, size 9

To change font size:
- `Ctrl+Plus` - Increase font size
- `Ctrl+Minus` - Decrease font size
- `Ctrl+0` - Reset font size

### Key Bindings

- `F11` - Toggle fullscreen
- `Ctrl+Shift+C` - Copy
- `Ctrl+Shift+V` - Paste
- `Shift+PageUp/Down` - Scroll

## Customization

### Opacity
Adjust window opacity (0.0 to 1.0):
```toml
[window]
opacity = 0.95
```

### Padding
Adjust terminal padding:
```toml
[window]
padding.x = 14
padding.y = 14
```

### Font
Change font family:
```toml
[font]
normal = { family = "Your Font Name", style = "Regular" }
size = 10
```

## Troubleshooting

### Font not found
Install the font via Homebrew:
```bash
brew install --cask font-caskaydia-mono-nerd-font
```

### Performance issues
Ensure GPU drivers are installed and working:
```bash
# Check OpenGL support
glxinfo | grep "OpenGL version"
```

### Colors look different
Check your display's color profile and terminal multiplexer settings (tmux/screen).

## Resources

- [Alacritty Documentation](https://alacritty.org/config-alacritty.html)
- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme)
- [Nerd Fonts](https://www.nerdfonts.com/)