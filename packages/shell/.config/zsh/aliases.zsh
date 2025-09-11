# Zsh Aliases
# Adapted from Omarchy configuration

# ─────────────────────────────────────────────────────────────────────────────
# File System & Navigation
# ─────────────────────────────────────────────────────────────────────────────
# Modern ls with eza (if available)
if command -v eza >/dev/null 2>&1; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='eza -lah --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='eza --tree --level=2 --long --icons --git -a'
else
  alias ls='ls --color=auto -lh'
  alias lsa='ls --color=auto -lah'
fi

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Directory shortcuts
alias ~='cd ~'
alias -- -='cd -'  # Go to previous directory

# ─────────────────────────────────────────────────────────────────────────────
# File Operations
# ─────────────────────────────────────────────────────────────────────────────
# Modern cat with bat (if available)
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=numbers,changes --wrap never'
  alias catp='bat --style=plain --wrap never'  # Plain bat
else
  alias cat='cat'
fi

# Archive operations
alias compress='tar -czf'
alias decompress='tar -xzf'

# File finding and searching
if command -v fd >/dev/null 2>&1; then
  alias find='fd'
fi

if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
fi

# FZF file finder with preview
if command -v fzf >/dev/null 2>&1 && command -v bat >/dev/null 2>&1; then
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
else
  alias ff='find . -type f | head -20'
fi

# ─────────────────────────────────────────────────────────────────────────────
# System Information
# ─────────────────────────────────────────────────────────────────────────────
# System monitoring
if command -v btop >/dev/null 2>&1; then
  alias top='btop'
  alias htop='btop'
fi

# System information
if command -v fastfetch >/dev/null 2>&1; then
  alias neofetch='fastfetch'
  alias screenfetch='fastfetch'
fi

# Disk usage
if command -v dust >/dev/null 2>&1; then
  alias du='dust'
fi

# ─────────────────────────────────────────────────────────────────────────────
# Development Tools
# ─────────────────────────────────────────────────────────────────────────────
# Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias dlog='docker logs -f'

# Git
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias gco='git checkout'
alias gst='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gba='git branch -a'

# Git utilities
alias gclean='git clean -fd && git checkout -- .'
alias greset='git reset --hard HEAD'

# Rails (if used)
alias r='rails'
alias rc='rails console'
alias rs='rails server'

# ─────────────────────────────────────────────────────────────────────────────
# Network & Web
# ─────────────────────────────────────────────────────────────────────────────
# HTTP requests
alias http='curl -i'
alias https='curl -i -k'

# Network tools
alias ping='ping -c 5'
alias ports='ss -tulpn'
alias ips="ip addr | grep 'inet ' | awk '{print \$2}' | cut -d/ -f1"

# ─────────────────────────────────────────────────────────────────────────────
# Package Management
# ─────────────────────────────────────────────────────────────────────────────
# Homebrew shortcuts
if command -v brew >/dev/null 2>&1; then
  alias brewup='brew update && brew upgrade'
  alias brewc='brew cleanup'
  alias brews='brew search'
  alias brewi='brew install'
fi

# ─────────────────────────────────────────────────────────────────────────────
# Productivity & Utils
# ─────────────────────────────────────────────────────────────────────────────
# Quick edits
alias zshrc='$EDITOR ~/.zshrc'
alias vimrc='$EDITOR ~/.config/nvim/init.lua'
alias hosts='$EDITOR /etc/hosts'  # Note: May require sudo to edit

# Process management
alias pgrep='pgrep -fl'
alias pkill='pkill -f'

# Memory and disk
alias meminfo='free -h'
alias diskinfo='df -h'

# Calendar
alias cal='cal -3'  # Show 3 months

# Weather (if installed)
if command -v curl >/dev/null 2>&1; then
  alias weather='curl -s "wttr.in/?format=3"'
  alias forecast='curl -s "wttr.in"'
fi

# ─────────────────────────────────────────────────────────────────────────────
# Safety Aliases
# ─────────────────────────────────────────────────────────────────────────────
# Confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# More verbose output
alias chmod='chmod -v'
alias chown='chown -v'

# ─────────────────────────────────────────────────────────────────────────────
# Fun & Misc
# ─────────────────────────────────────────────────────────────────────────────
# Colorize output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# Human readable sizes
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Directory listing shortcuts
alias lsd='ls -d */'  # List only directories
alias lsf='ls -p | grep -v /'  # List only files

# Quick parent directory access
alias cd1='cd ..'
alias cd2='cd ../..'
alias cd3='cd ../../..'
alias cd4='cd ../../../..'
alias cd5='cd ../../../../..'

# ─────────────────────────────────────────────────────────────────────────────
# Platform-specific aliases
# ─────────────────────────────────────────────────────────────────────────────
case "$OSTYPE" in
  darwin*)
    # macOS specific aliases
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO'
    alias finder='open -a Finder'
    ;;
  linux*)
    # Linux specific aliases
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    ;;
esac

# WSL specific
if grep -qi microsoft /proc/version 2>/dev/null; then
  alias cmd='cmd.exe'
  alias powershell='powershell.exe'
  alias pwsh='pwsh.exe'
  alias explorer='explorer.exe'
fi