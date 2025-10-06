# Shell Aliases Reference

Complete reference for all shell aliases defined in this dotfiles configuration.

## File System & Navigation

### Directory Listing
```bash
ls          # eza -lh --group-directories-first --icons=auto
lsa         # eza -lah --group-directories-first --icons=auto (all files)
lt          # eza --tree --level=2 --long --icons --git (tree view)
lta         # eza --tree --level=2 --long --icons --git -a (tree with hidden)
ll          # ls -alF
la          # ls -A
l           # ls -CF
lsd         # ls -d */ (directories only)
lsf         # ls -p | grep -v / (files only)
```

### Navigation Shortcuts
```bash
..          # cd ..
...         # cd ../..
....        # cd ../../..
.....       # cd ../../../..
~           # cd ~
-           # cd - (previous directory)

# Alternative navigation
cd1         # cd ..
cd2         # cd ../..
cd3         # cd ../../..
cd4         # cd ../../../..
cd5         # cd ../../../../..
```

## File Operations

### File Viewing
```bash
cat         # bat --style=numbers,changes --wrap never
catp        # bat --style=plain --wrap never (plain output)
```

### File Finding & Searching
```bash
find        # fd (modern find alternative)
grep        # rg (ripgrep)
ff          # fzf --preview 'bat --style=numbers --color=always {}' (fuzzy finder)
```

## Git Shortcuts

### Basic Commands
```bash
g           # git
ga          # git add
gaa         # git add .
gc          # git commit
gcm         # git commit -m
gcam        # git commit -a -m
gcad        # git commit -a --amend
gco         # git checkout
gst         # git status
gd          # git diff
```

### Logging & Branches
```bash
gl          # git log --oneline --graph --decorate
gb          # git branch
gba         # git branch -a
```

### Remote Operations
```bash
gp          # git push
gpl         # git pull
```

### Cleanup & Reset
```bash
gclean      # git clean -fd && git checkout -- .
greset      # git reset --hard HEAD
```

## Docker

```bash
d           # docker
dc          # docker-compose
dps         # docker ps
dpsa        # docker ps -a
dimg        # docker images
dlog        # docker logs -f
```

## System Information & Monitoring

```bash
top         # btop
htop        # btop
du          # dust
neofetch    # fastfetch
screenfetch # fastfetch
meminfo     # free -h
diskinfo    # df -h
```

## Network & Web

```bash
http        # curl -i
https       # curl -i -k
ping        # ping -c 5
ports       # ss -tulpn
ips         # ip addr | grep 'inet ' | awk '{print $2}' | cut -d/ -f1
```

## Package Management (Homebrew)

```bash
brewup      # brew update && brew upgrade
brewc       # brew cleanup
brews       # brew search
brewi       # brew install
```

## Development Tools

### Rails
```bash
r           # rails
rc          # rails console
rs          # rails server
```

## Quick File Edits

```bash
zshrc       # $EDITOR ~/.zshrc
vimrc       # $EDITOR ~/.config/nvim/init.lua
hosts       # $EDITOR /etc/hosts (may require sudo)
```

## Process Management

```bash
pgrep       # pgrep -fl
pkill       # pkill -f
```

## Safety & Confirmation

```bash
cp          # cp -i (confirm before overwrite)
mv          # mv -i (confirm before overwrite)
rm          # rm -i (confirm before delete)
chmod       # chmod -v (verbose)
chown       # chown -v (verbose)
```

## Utilities

```bash
cal         # cal -3 (show 3 months)
```

## Colorized Output

```bash
grep        # grep --color=auto
fgrep       # fgrep --color=auto
egrep       # egrep --color=auto
diff        # diff --color=auto
ip          # ip -color=auto
```

## Platform-Specific Aliases

### macOS Only
```bash
showfiles   # defaults write com.apple.finder AppleShowAllFiles YES
hidefiles   # defaults write com.apple.finder AppleShowAllFiles NO
finder      # open -a Finder
```

### Linux Only
```bash
pbcopy      # xclip -selection clipboard
pbpaste     # xclip -selection clipboard -o
```

### WSL Only
```bash
cmd         # cmd.exe
powershell  # powershell.exe
pwsh        # pwsh.exe
explorer    # explorer.exe
```

## Modern Tool Replacements

This configuration replaces traditional Unix tools with modern alternatives:

| Traditional | Modern Alternative | Alias |
|-------------|-------------------|-------|
| `ls` | `eza` | `ls`, `lsa`, `lt`, `lta` |
| `cat` | `bat` | `cat`, `catp` |
| `find` | `fd` | `find` |
| `grep` | `ripgrep` | `grep` |
| `cd` | `zoxide` | `zd` (function) |
| `du` | `dust` | `du` |
| `top` | `btop` | `top`, `htop` |
| `neofetch` | `fastfetch` | `neofetch`, `screenfetch` |

## Related Documentation

- [Shell Functions](./FUNCTIONS.md) - Custom shell functions
- [Shell README](./README.md) - Shell configuration overview
- [Main README](../../README.md) - Dotfiles overview

## Notes

- Aliases are defined in `packages/shell/.config/zsh/aliases.zsh`
- All aliases check for tool availability before creating the alias
- If modern tools are not installed, aliases fall back to traditional commands
- Use `just install-packages` to install all recommended tools
