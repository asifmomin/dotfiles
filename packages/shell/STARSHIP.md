# Starship Prompt Configuration

Cross-shell prompt with Tokyo Night theme and comprehensive Git integration.

## Features

- **Tokyo Night color scheme** throughout
- **Two styles**: Full-featured powerline and minimal
- **Git integration** with detailed status indicators
- **Language detection** for development projects
- **Performance optimized** with selective module loading
- **Cross-platform** support (macOS, Linux, WSL)

## Styles

### Default (Full-featured)
A powerline-style prompt with segments for:
- Username (when SSH or root)
- Directory with icons
- Git branch and status
- Programming languages
- Docker/Conda environments
- Time
- Command duration
- Battery status (laptops)

```
 ~/dotfiles  main  ❯
```

### Minimal (Omarchy-style)
A clean, simple prompt with just:
- Current directory
- Git branch and status
- Prompt character

```
~/dotfiles main ❯
```

## Installation

The Starship configuration is included in the shell package:

```bash
# Apply shell package (includes Starship config)
cd ~/dotfiles
just stow-apply

# Install Starship if not already installed
brew install starship
```

## Configuration

### Switch Prompt Styles
```bash
# Show available styles
prompt-switch

# Switch to minimal style
prompt-switch minimal

# Switch back to default
prompt-switch default

# Use custom configuration
prompt-switch custom
```

### Custom Configuration
Create your own style:
```bash
cp ~/.config/starship.toml ~/.config/starship-custom.toml
# Edit the custom file
nvim ~/.config/starship-custom.toml
# Apply it
prompt-switch custom
```

## Module Details

### Directory Module
- Truncates to 3 levels by default
- Shows home as 
- Repository root in different color
- Custom icons for common directories

### Git Module
- **Branch**: Shows current branch name
- **Status symbols**:
  -  Modified files
  -  Staged changes
  - ? Untracked files
  - 󰏗 Stashed changes
  - ⇡ Ahead of remote
  - ⇣ Behind remote
  - 🏳 Merge conflicts

### Language Modules
Automatically detects and shows versions for:
-  Node.js
-  Python
-  Ruby
-  Rust
-  Go
-  PHP
-  Java
-  Docker

### Performance Features
- **Conditional loading**: Languages only shown in relevant projects
- **Fast timeouts**: 500ms command timeout
- **Minimal stat calls**: Efficient file detection

## Tokyo Night Colors Used

| Element | Color | Hex |
|---------|-------|-----|
| Success | Green | #9ece6a |
| Error | Red | #f7768e |
| Directory | Cyan | #7dcfff |
| Git | Blue | #7aa2f7 |
| Git Status | Purple | #bb9af7 |
| Duration | Yellow | #e0af68 |
| Background | Dark | #1a1b26 |

## Customization

### Change Prompt Character
Edit `~/.config/starship.toml`:
```toml
[character]
success_symbol = "[➜](bold fg:#9ece6a)"  # Change arrow
error_symbol = "[✗](bold fg:#f7768e)"
```

### Adjust Directory Truncation
```toml
[directory]
truncation_length = 5  # Show more path segments
truncate_to_repo = false  # Don't truncate at repo root
```

### Disable Modules
```toml
[nodejs]
disabled = true  # Don't show Node.js version
```

### Add Custom Module
```toml
[custom.docker]
command = "docker --version | cut -d' ' -f3 | cut -d',' -f1"
when = "docker info"
symbol = "🐳 "
style = "bold fg:#7aa2f7"
format = "[$symbol$output]($style) "
```

## Performance Tips

### Slow Prompt?
1. Check which module is slow:
   ```bash
   starship timings
   ```

2. Disable slow modules:
   ```toml
   [package]
   disabled = true
   ```

3. Reduce scan timeout:
   ```toml
   scan_timeout = 10
   ```

### Git Performance
For large repositories:
```toml
[git_status]
disabled = true  # Disable git status entirely
# OR
ahead_behind = false  # Don't check remote status
```

## Troubleshooting

### Prompt Not Showing
Ensure Starship is initialized in your shell:
```bash
# Check ~/.config/zsh/.zshrc for:
eval "$(starship init zsh)"
```

### Icons Not Displaying
Install a Nerd Font:
```bash
brew install --cask font-caskaydia-mono-nerd-font
```

### Colors Look Wrong
- Check terminal supports 256 colors: `echo $TERM`
- Should be `xterm-256color` or similar
- In tmux, ensure: `set -g default-terminal "screen-256color"`

## Integration with Shell

The Starship prompt is automatically loaded by the Zsh configuration:
- Initialization in `~/.config/zsh/.zshrc`
- Works with any shell (bash, zsh, fish, powershell)
- Respects `$STARSHIP_CONFIG` environment variable

## Resources

- [Starship Documentation](https://starship.rs/)
- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme)
- [Nerd Fonts](https://www.nerdfonts.com/)