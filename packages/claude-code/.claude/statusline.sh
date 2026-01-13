#!/usr/bin/env bash
# Claude Code Status Line
# Matches Starship minimal prompt with Tokyo Night colors
# Format: [directory git_branch git_status] character

# Read JSON input from stdin
input=$(cat)

# DEBUG: Uncomment to see all available fields
echo "$input" | jq '.' > /tmp/claude-statusline-debug.json

# Extract current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

# Tokyo Night color codes (dimmed for status line)
CYAN="\033[38;2;125;207;255m"      # #7dcfff - directory
GREEN="\033[38;2;158;206;106m"     # #9ece6a - repo root
BLUE="\033[38;2;122;162;247m"      # #7aa2f7 - git branch and prompt
PURPLE="\033[38;2;187;154;247m"    # #bb9af7 - git status
BOLD="\033[1m"
ITALIC="\033[3m"
RESET="\033[0m"

# Change to the working directory
cd "$cwd" 2>/dev/null || exit 1

# Git repository detection
git_root=$(git -c core.useBuiltinFSMonitor=false rev-parse --show-toplevel 2>/dev/null)
is_git_repo=$?

# Directory formatting
if [[ $is_git_repo -eq 0 ]]; then
    # In a git repo - show repo root in green, path in cyan
    repo_name=$(basename "$git_root")

    if [[ "$cwd" == "$git_root" ]]; then
        # At repo root
        dir_display="${BOLD}${GREEN}${repo_name}${RESET}"
    else
        # Inside repo - show relative path
        relative_path="${cwd#$git_root/}"
        dir_display="${BOLD}${GREEN}${repo_name}${RESET}${BOLD}${CYAN}/${relative_path}${RESET}"
    fi
else
    # Not in git repo - show directory with truncation
    if [[ "$cwd" == "$HOME" ]]; then
        dir_display="${BOLD}${CYAN}~${RESET}"
    else
        dir_display="${BOLD}${CYAN}${cwd/#$HOME/\~}${RESET}"
    fi
fi

# Git branch
git_branch=""
if [[ $is_git_repo -eq 0 ]]; then
    branch=$(git -c core.useBuiltinFSMonitor=false symbolic-ref --short HEAD 2>/dev/null || git -c core.useBuiltinFSMonitor=false rev-parse --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        git_branch="${ITALIC}${BLUE}${branch}${RESET} "
    fi
fi

# Git status
git_status=""
if [[ $is_git_repo -eq 0 ]]; then
    status_output=$(git -c core.useBuiltinFSMonitor=false status --porcelain 2>/dev/null)

    untracked=0
    modified=0
    staged=0

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        index_status="${line:0:1}"
        work_status="${line:1:1}"

        # Check staged changes (index)
        if [[ "$index_status" =~ [MADRC] ]]; then
            ((staged++))
        fi

        # Check working tree changes
        if [[ "$work_status" == "M" ]]; then
            ((modified++))
        fi

        # Check untracked
        if [[ "$index_status" == "?" ]]; then
            ((untracked++))
        fi
    done <<< "$status_output"

    status_parts=""
    [[ $staged -gt 0 ]] && status_parts+=" "
    [[ $modified -gt 0 ]] && status_parts+=" "
    [[ $untracked -gt 0 ]] && status_parts+="? "

    if [[ -n "$status_parts" ]]; then
        git_status="${PURPLE}${status_parts}${RESET}"
    fi
fi

# Build final prompt (no trailing $ or >)
printf "[${dir_display}${git_branch}${git_status}]${BOLD}${BLUE}❯${RESET}"
