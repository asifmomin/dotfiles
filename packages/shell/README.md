# Shell Configuration (Zsh)

Modern Zsh configuration adapted from Omarchy with XDG Base Directory compliance.

## Features

- **XDG-compliant** configuration structure
- **Tokyo Night** color scheme integration
- **Modern CLI tools** integration (eza, bat, fzf, zoxide)
- **Comprehensive aliases** from Omarchy
- **Smart functions** for productivity
- **Cross-platform** compatibility (macOS, Linux, WSL)

## Installation

```bash
# Apply configuration via stow
cd ~/dotfiles
just stow-apply

# Or manually
stow -d packages -t ~ shell
```

## Structure

```
shell/
├── .zshrc                     # Legacy shim (sources XDG config)
└── .config/
    └── zsh/
        ├── .zshrc             # Main configuration
        ├── aliases.zsh        # Command aliases
        ├── functions.zsh      # Custom functions
        ├── local.zsh.example  # Local config template
        └── local.zsh          # Personal overrides (gitignored)
```

## Configuration Files

### Main Config (`.zshrc`)
- XDG Base Directory setup
- History configuration
- Zsh options and key bindings
- Tool initialization (Starship, Zoxide, Direnv, etc.)

### Aliases (`aliases.zsh`)
- File system navigation (`ls` → `eza`, `cat` → `bat`)
- Git shortcuts (`g`, `gcm`, `gst`, etc.)
- Development tools (`d` → `docker`, `r` → `rails`)
- System utilities and modern CLI replacements

### Functions (`functions.zsh`)
- Smart navigation (`zd`, `mkcd`, `up`)
- File operations (`extract`, `compress`, `n`)
- Development helpers (`gclone`, `ginit`, `find_replace`)
- Media processing (`transcode-video-1080p`, `img2jpg`)
- System utilities (`sysinfo`, `largest`, `myip`)

## Key Features

### Modern CLI Integration
- **eza** for enhanced `ls` with icons and git status
- **bat** for syntax-highlighted `cat` with line numbers
- **fzf** for fuzzy finding with Tokyo Night colors
- **zoxide** for smart `cd` with frecency algorithm
- **ripgrep** for fast text searching

### Smart Functions
- `n [files]` - Open neovim (current dir if no args)
- `zd [path]` - Smart cd with zoxide integration
- `extract <file>` - Extract any archive format
- `gconv <type> [scope] <message>` - Conventional git commits
- `serve [port]` - Quick HTTP server (default port 8000)

### Git Workflow
```bash
g st           # git status
ga .           # git add .
gcm "message"  # git commit -m "message"
gp             # git push
```

### Docker Shortcuts
```bash
d ps           # docker ps
dc up          # docker-compose up
dlog <name>    # docker logs -f <name>
```

## Customization

### Personal Configuration
1. Copy the example file:
   ```bash
   cp ~/.config/zsh/local.zsh.example ~/.config/zsh/local.zsh
   ```

2. Add your personal configuration:
   ```bash
   # ~/.config/zsh/local.zsh
   export EDITOR="code"
   alias work='cd ~/workspace'
   
   # Custom function
   deploy() {
     echo "Deploying..."
     # Your deployment logic
   }
   ```

### Environment Variables
The configuration sets these key variables:
- `EDITOR=nvim` - Default editor
- `BAT_THEME=TwoDark` - Bat theme (close to Tokyo Night)
- `FZF_DEFAULT_OPTS` - Tokyo Night colors for fzf
- `XDG_*` variables for proper directory structure

### History Configuration
- 32,768 commands in history
- Duplicate removal
- Shared history between sessions
- Stored in `~/.local/state/zsh/history`

## Tool Dependencies

### Required
- `zsh` - Shell
- `git` - Version control

### Recommended
- `starship` - Cross-shell prompt
- `eza` - Modern ls replacement
- `bat` - Better cat with syntax highlighting
- `fzf` - Fuzzy finder
- `zoxide` - Smart cd replacement
- `ripgrep` - Fast text search
- `fd` - Fast find replacement

### Optional
- `btop` - System monitor
- `dust` - Disk usage analyzer
- `fastfetch` - System information
- `direnv` - Per-directory environment
- `mise` - Runtime version manager

## Platform Notes

### macOS
- Uses Homebrew for package management
- Includes macOS-specific aliases (flushdns, showfiles)

### Linux
- Works with any distribution
- Includes Linux-specific aliases (pbcopy/pbpaste via xclip)

### WSL
- Auto-detected and includes Windows integration
- Aliases for cmd.exe, powershell.exe, explorer.exe

## Troubleshooting

### Slow startup
Check which tools are causing delays:
```bash
zsh -xvs 2>&1 | ts -i "%.s" | head -50
```

### Missing completions
Rebuild completion cache:
```bash
rm ~/.cache/zsh/zcompdump-*
exec zsh
```

### Tool not found
Install missing tools:
```bash
just install-packages
```

## Migration from Bash

1. Install zsh: `brew install zsh`
2. Apply dotfiles: `just stow-apply`
3. Change default shell: `chsh -s $(which zsh)`
4. Copy any custom bash config to `~/.config/zsh/local.zsh`

## Resources

- [Zsh Manual](http://zsh.sourceforge.net/Doc/)
- [Starship Prompt](https://starship.rs/)
- [Modern Unix Tools](https://github.com/ibraheemdev/modern-unix)