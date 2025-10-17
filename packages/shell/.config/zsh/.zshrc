# Zsh Configuration
# Adapted from Omarchy with Tokyo Night theme integration

# ─────────────────────────────────────────────────────────────────────────────
# XDG Base Directory
# ─────────────────────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# ─────────────────────────────────────────────────────────────────────────────
# Zsh Configuration Directory
# ─────────────────────────────────────────────────────────────────────────────
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# ─────────────────────────────────────────────────────────────────────────────
# History Configuration
# ─────────────────────────────────────────────────────────────────────────────
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export HISTSIZE=32768
export SAVEHIST=32768

# Create history directory if it doesn't exist
[[ ! -d "${XDG_STATE_HOME}/zsh" ]] && mkdir -p "${XDG_STATE_HOME}/zsh"

# History options
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from history
setopt HIST_SAVE_NO_DUPS     # Don't save duplicates
setopt INC_APPEND_HISTORY    # Immediately append history
setopt SHARE_HISTORY         # Share history between sessions

# ─────────────────────────────────────────────────────────────────────────────
# Environment Variables
# ─────────────────────────────────────────────────────────────────────────────
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R"
export BAT_THEME="TwoDark"  # Close to Tokyo Night

# Path configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="./bin:$PATH"

# Homebrew initialization (Linux/WSL)
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -d "$HOME/.linuxbrew" ]]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
fi

# FZF configuration with Tokyo Night colors
export FZF_DEFAULT_OPTS="
  --color=bg+:#283457,bg:#16161e,spinner:#bb9af7,hl:#7aa2f7
  --color=fg:#a9b1d6,header:#7aa2f7,info:#e0af68,pointer:#bb9af7
  --color=marker:#9ece6a,fg+:#a9b1d6,prompt:#7aa2f7,hl+:#7aa2f7
  --border --height=40% --layout=reverse --info=inline --margin=1
  --preview 'bat --style=numbers --color=always {}'
"

# ─────────────────────────────────────────────────────────────────────────────
# Zsh Options
# ─────────────────────────────────────────────────────────────────────────────
setopt AUTO_CD              # Auto cd to a directory without typing cd
setopt AUTO_PUSHD          # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS  # Don't store duplicates in the stack
setopt PUSHD_SILENT       # Don't print the directory stack after pushd/popd
setopt CORRECT            # Correct typos in commands
setopt CDABLE_VARS       # Change directory to a path stored in a variable
setopt EXTENDED_GLOB     # Use extended globbing syntax

# ─────────────────────────────────────────────────────────────────────────────
# Completion System
# ─────────────────────────────────────────────────────────────────────────────
# Create cache directory if it doesn't exist
[[ ! -d "${XDG_CACHE_HOME}/zsh" ]] && mkdir -p "${XDG_CACHE_HOME}/zsh"

# Load and initialize the completion system
autoload -Uz compinit

# Use XDG directory for zcompdump
# Only rebuild completion cache once per day for faster startup
# Use glob qualifiers: N (null if no match), mh-24 (modified less than 24 hours ago)
_zcompdump="${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
if [[ -s "$_zcompdump" && (! -s "${_zcompdump}.zwc" || "$_zcompdump" -nt "${_zcompdump}.zwc") ]]; then
  # Compile zcompdump for faster loading
  zcompile "$_zcompdump"
fi
for _dump in "$_zcompdump"(Nmh-24); do
  # Cache is less than 24 hours old, skip expensive check
  compinit -C -d "$_zcompdump"
  break
done
[[ -z "$_dump" ]] && compinit -d "$_zcompdump"
unset _zcompdump _dump

# Completion options
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%F{green}── %d ──%f%b'
zstyle ':completion:*:messages' format '%B%F{yellow}── %d ──%f%b'
zstyle ':completion:*:warnings' format '%B%F{red}── no matches found ──%f%b'

# ─────────────────────────────────────────────────────────────────────────────
# Key Bindings
# ─────────────────────────────────────────────────────────────────────────────
bindkey -e  # Emacs key bindings

# History search
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^R' history-incremental-search-backward

# Edit command line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# ─────────────────────────────────────────────────────────────────────────────
# Source Configuration Files
# ─────────────────────────────────────────────────────────────────────────────
# Load aliases
[[ -f "${ZDOTDIR}/aliases.zsh" ]] && source "${ZDOTDIR}/aliases.zsh"

# Load functions
[[ -f "${ZDOTDIR}/functions.zsh" ]] && source "${ZDOTDIR}/functions.zsh"

# Load local/private configuration
[[ -f "${ZDOTDIR}/local.zsh" ]] && source "${ZDOTDIR}/local.zsh"

# ─────────────────────────────────────────────────────────────────────────────
# Tool Initialization
# ─────────────────────────────────────────────────────────────────────────────
# Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Zoxide (smart cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# FZF
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
fi

# Mise (runtime manager)
# Lazy load mise for faster startup - only fully activate when needed
if command -v mise >/dev/null 2>&1; then
  # Add mise shims to PATH immediately (fast)
  export PATH="$HOME/.local/share/mise/shims:$PATH"

  # Define lazy loader that activates mise on first use
  _mise_lazy_load() {
    unfunction mise python node npm pnpm 2>/dev/null
    eval "$(mise activate zsh)"
    mise "$@"
  }

  # Create function wrapper for mise command
  mise() { _mise_lazy_load "$@"; }

  # Optional: create wrappers for commonly used mise-managed tools
  # Uncomment if you want instant activation when using these commands
  # python() { _mise_lazy_load; unfunction python; python "$@"; }
  # node() { _mise_lazy_load; unfunction node; node "$@"; }
fi

# Corepack (package manager manager for Node.js)
# Enables pnpm, yarn without global installs
if command -v corepack >/dev/null 2>&1; then
  export COREPACK_ENABLE_STRICT=0  # Don't enforce package manager version unless specified
  corepack enable >/dev/null 2>&1 || true
fi

# ─────────────────────────────────────────────────────────────────────────────
# Welcome Message
# ─────────────────────────────────────────────────────────────────────────────
# Disabled - uncomment to show system info on startup
# if [[ -o interactive ]]; then
#   if command -v fastfetch >/dev/null 2>&1; then
#     fastfetch --logo small
#   fi
# fi