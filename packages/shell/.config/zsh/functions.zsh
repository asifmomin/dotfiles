# Zsh Functions
# Adapted from Omarchy configuration

# ─────────────────────────────────────────────────────────────────────────────
# Navigation & Directory Functions
# ─────────────────────────────────────────────────────────────────────────────
# Smart cd with zoxide integration (adapted from Omarchy's zd function)
zd() {
  if [[ $# -eq 0 ]]; then
    builtin cd ~ && return
  elif [[ -d "$1" ]]; then
    builtin cd "$1"
  else
    # Use zoxide if available, otherwise fallback to regular cd
    if command -v z >/dev/null 2>&1; then
      z "$@" && printf "📁 " && pwd || echo "Error: Directory not found"
    else
      echo "Directory not found: $1"
      return 1
    fi
  fi
}

# Override cd with smart version
alias cd="zd"

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Go up n directories
up() {
  local levels=${1:-1}
  local path=""
  for ((i = 0; i < levels; i++)); do
    path="../$path"
  done
  cd "${path:0:-1}"
}

# ─────────────────────────────────────────────────────────────────────────────
# File Operations
# ─────────────────────────────────────────────────────────────────────────────
# Smart neovim function (adapted from Omarchy's n function)
n() {
  if [[ "$#" -eq 0 ]]; then
    nvim .
  else
    nvim "$@"
  fi
}

# Open files/directories with appropriate application
open() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    command open "$@"
  elif [[ "$OSTYPE" == "linux"* ]]; then
    xdg-open "$@" >/dev/null 2>&1 &
  else
    echo "Unsupported platform for open function"
  fi
}

# Extract various archive formats
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Compression function (adapted from Omarchy)
compress() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: compress <directory_name>"
    echo "Creates: <directory_name>.tar.gz"
    return 1
  fi
  tar -czf "${1%/}.tar.gz" "${1%/}"
  echo "Created: ${1%/}.tar.gz"
}

# ─────────────────────────────────────────────────────────────────────────────
# Development Functions
# ─────────────────────────────────────────────────────────────────────────────
# Git functions
gclone() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

# Create new git repository
ginit() {
  git init
  git add .
  git commit -m "Initial commit"
}

# Git commit with conventional commit format
gconv() {
  local type="$1"
  local scope="$2"
  local message="$3"
  
  if [[ -z "$type" || -z "$message" ]]; then
    echo "Usage: gconv <type> [scope] <message>"
    echo "Types: feat, fix, docs, style, refactor, test, chore"
    return 1
  fi
  
  if [[ -n "$scope" ]]; then
    git commit -m "${type}(${scope}): ${message}"
  else
    git commit -m "${type}: ${message}"
  fi
}

# Find and replace in files
find_replace() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: find_replace <search_pattern> <replacement>"
    return 1
  fi
  
  if command -v rg >/dev/null 2>&1; then
    rg -l "$1" | xargs sed -i "s/$1/$2/g"
  else
    grep -rl "$1" . | xargs sed -i "s/$1/$2/g"
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
# System Functions
# ─────────────────────────────────────────────────────────────────────────────
# System information
sysinfo() {
  echo "System Information:"
  echo "OS: $(uname -s)"
  echo "Kernel: $(uname -r)"
  echo "Architecture: $(uname -m)"
  echo "Hostname: $(hostname)"
  echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
  echo "Shell: $SHELL"
  echo "Terminal: $TERM"
}

# Find largest files/directories
largest() {
  if command -v dust >/dev/null 2>&1; then
    dust -d 1 -r
  else
    du -ah . | sort -rh | head -20
  fi
}

# Process finder
psgrep() {
  if [[ -z "$1" ]]; then
    echo "Usage: psgrep <process_name>"
    return 1
  fi
  ps aux | grep -i "$1" | grep -v grep
}

# Port checker
port_check() {
  if [[ -z "$1" ]]; then
    echo "Usage: port_check <port>"
    return 1
  fi
  
  if command -v ss >/dev/null 2>&1; then
    ss -tulpn | grep ":$1"
  else
    netstat -tulpn | grep ":$1"
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Media Functions (adapted from Omarchy)
# ─────────────────────────────────────────────────────────────────────────────
# Transcode video to 1080p
transcode-video-1080p() {
  if [[ -z "$1" ]]; then
    echo "Usage: transcode-video-1080p <input_file>"
    return 1
  fi
  
  if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Error: ffmpeg not installed"
    return 1
  fi
  
  local output="${1%.*}-1080p.mp4"
  ffmpeg -i "$1" -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy "$output"
  echo "Created: $output"
}

# Transcode video to 4K
transcode-video-4K() {
  if [[ -z "$1" ]]; then
    echo "Usage: transcode-video-4K <input_file>"
    return 1
  fi
  
  if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Error: ffmpeg not installed"
    return 1
  fi
  
  local output="${1%.*}-optimized.mp4"
  ffmpeg -i "$1" -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k "$output"
  echo "Created: $output"
}

# Convert image to optimized JPG
img2jpg() {
  if [[ -z "$1" ]]; then
    echo "Usage: img2jpg <input_image>"
    return 1
  fi
  
  if ! command -v magick >/dev/null 2>&1; then
    echo "Error: ImageMagick not installed"
    return 1
  fi
  
  local output="${1%.*}.jpg"
  magick "$1" -quality 95 -strip "$output"
  echo "Created: $output"
}

# Convert image to small JPG for web
img2jpg-small() {
  if [[ -z "$1" ]]; then
    echo "Usage: img2jpg-small <input_image>"
    return 1
  fi
  
  if ! command -v magick >/dev/null 2>&1; then
    echo "Error: ImageMagick not installed"
    return 1
  fi
  
  local output="${1%.*}-small.jpg"
  magick "$1" -resize 1080x\> -quality 95 -strip "$output"
  echo "Created: $output"
}

# Convert image to optimized PNG
img2png() {
  if [[ -z "$1" ]]; then
    echo "Usage: img2png <input_image>"
    return 1
  fi
  
  if ! command -v magick >/dev/null 2>&1; then
    echo "Error: ImageMagick not installed"
    return 1
  fi
  
  local output="${1%.*}.png"
  magick "$1" -strip -define png:compression-filter=5 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    -define png:exclude-chunk=all \
    "$output"
  echo "Created: $output"
}

# ─────────────────────────────────────────────────────────────────────────────
# Network Functions
# ─────────────────────────────────────────────────────────────────────────────
# Get external IP
myip() {
  if command -v curl >/dev/null 2>&1; then
    curl -s ifconfig.me
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- ifconfig.me
  else
    echo "curl or wget required"
  fi
}

# Local IP addresses
localip() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'
  else
    ip addr | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1
  fi
}

# Quick HTTP server
serve() {
  local port=${1:-8000}
  if command -v python3 >/dev/null 2>&1; then
    python3 -m http.server "$port"
  elif command -v python >/dev/null 2>&1; then
    python -m SimpleHTTPServer "$port"
  else
    echo "Python not found"
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Utility Functions
# ─────────────────────────────────────────────────────────────────────────────
# Create backup of a file
backup() {
  if [[ -z "$1" ]]; then
    echo "Usage: backup <file>"
    return 1
  fi
  cp "$1" "${1}.backup.$(date +%Y%m%d_%H%M%S)"
}

# Generate random password
genpass() {
  local length=${1:-16}
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -base64 "$length" | tr -d "=+/" | cut -c1-"$length"
  else
    LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$length"
    echo
  fi
}

# QR code generator
qr() {
  if [[ -z "$1" ]]; then
    echo "Usage: qr <text_to_encode>"
    return 1
  fi
  
  if command -v qrencode >/dev/null 2>&1; then
    qrencode -t UTF8 "$1"
  else
    echo "qrencode not installed"
  fi
}