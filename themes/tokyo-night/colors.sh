#!/usr/bin/env bash
# Tokyo Night Color Palette
# Unified color variables for consistent theming across all applications

# ==============================================================================
# TOKYO NIGHT COLOR PALETTE
# ==============================================================================

# Base colors
export TOKYO_NIGHT_BG="#1a1b26"           # Main background (dark blue-black)
export TOKYO_NIGHT_BG_DARK="#16161e"      # Darker background
export TOKYO_NIGHT_BG_HIGHLIGHT="#283457" # Highlight background
export TOKYO_NIGHT_FG="#a9b1d6"           # Main foreground (light blue-gray)
export TOKYO_NIGHT_FG_DARK="#9aa5ce"      # Darker foreground
export TOKYO_NIGHT_FG_GUTTER="#3b4261"    # Gutter foreground

# Primary colors
export TOKYO_NIGHT_RED="#f7768e"          # Error, deletion, negative
export TOKYO_NIGHT_ORANGE="#ff9e64"       # Warning, modification
export TOKYO_NIGHT_YELLOW="#e0af68"       # Caution, information
export TOKYO_NIGHT_GREEN="#9ece6a"        # Success, addition, positive
export TOKYO_NIGHT_BLUE="#7aa2f7"         # Primary, links, keywords
export TOKYO_NIGHT_CYAN="#7dcfff"         # Secondary, strings, literals
export TOKYO_NIGHT_PURPLE="#bb9af7"       # Accent, special, functions
export TOKYO_NIGHT_MAGENTA="#c0caf5"      # Variables, constants

# Semantic colors
export TOKYO_NIGHT_ERROR="$TOKYO_NIGHT_RED"
export TOKYO_NIGHT_WARNING="$TOKYO_NIGHT_ORANGE"
export TOKYO_NIGHT_INFO="$TOKYO_NIGHT_CYAN"
export TOKYO_NIGHT_SUCCESS="$TOKYO_NIGHT_GREEN"

# Git colors
export TOKYO_NIGHT_GIT_ADD="$TOKYO_NIGHT_GREEN"
export TOKYO_NIGHT_GIT_CHANGE="$TOKYO_NIGHT_YELLOW"
export TOKYO_NIGHT_GIT_DELETE="$TOKYO_NIGHT_RED"
export TOKYO_NIGHT_GIT_BRANCH="$TOKYO_NIGHT_CYAN"
export TOKYO_NIGHT_GIT_REMOTE="$TOKYO_NIGHT_PURPLE"

# Neutral colors
export TOKYO_NIGHT_GRAY="#565f89"         # Comments, disabled text
export TOKYO_NIGHT_GRAY_DARK="#414868"    # Borders, separators
export TOKYO_NIGHT_GRAY_LIGHT="#737aa2"   # Secondary text

# Terminal colors (0-15)
export TOKYO_NIGHT_BLACK="$TOKYO_NIGHT_BG_DARK"        # 0
export TOKYO_NIGHT_BRIGHT_BLACK="$TOKYO_NIGHT_GRAY"    # 8
export TOKYO_NIGHT_WHITE="$TOKYO_NIGHT_FG"             # 7
export TOKYO_NIGHT_BRIGHT_WHITE="$TOKYO_NIGHT_FG"      # 15

# ==============================================================================
# APPLICATION-SPECIFIC COLOR MAPPINGS
# ==============================================================================

# Alacritty terminal colors
export ALACRITTY_BG="$TOKYO_NIGHT_BG"
export ALACRITTY_FG="$TOKYO_NIGHT_FG"
export ALACRITTY_CURSOR="$TOKYO_NIGHT_FG"
export ALACRITTY_SELECTION_BG="$TOKYO_NIGHT_BG_HIGHLIGHT"

# Tmux status line colors
export TMUX_BG="$TOKYO_NIGHT_BG"
export TMUX_FG="$TOKYO_NIGHT_FG"
export TMUX_ACTIVE="$TOKYO_NIGHT_BLUE"
export TMUX_INACTIVE="$TOKYO_NIGHT_GRAY"
export TMUX_ACCENT="$TOKYO_NIGHT_GREEN"

# Git diff colors
export GIT_DIFF_ADD="$TOKYO_NIGHT_GREEN"
export GIT_DIFF_DELETE="$TOKYO_NIGHT_RED"
export GIT_DIFF_CHANGE="$TOKYO_NIGHT_YELLOW"
export GIT_DIFF_META="$TOKYO_NIGHT_CYAN"

# FZF colors (for shell integration)
export FZF_BG="$TOKYO_NIGHT_BG"
export FZF_FG="$TOKYO_NIGHT_FG"
export FZF_HL="$TOKYO_NIGHT_BLUE"
export FZF_BG_PLUS="$TOKYO_NIGHT_BG_HIGHLIGHT"

# Starship prompt colors
export STARSHIP_SUCCESS="$TOKYO_NIGHT_GREEN"
export STARSHIP_ERROR="$TOKYO_NIGHT_RED"
export STARSHIP_DIRECTORY="$TOKYO_NIGHT_CYAN"
export STARSHIP_GIT="$TOKYO_NIGHT_BLUE"

# Btop system monitor colors
export BTOP_CPU_START="$TOKYO_NIGHT_GREEN"
export BTOP_CPU_MID="$TOKYO_NIGHT_YELLOW"
export BTOP_CPU_END="$TOKYO_NIGHT_RED"
export BTOP_MEM_START="$TOKYO_NIGHT_BLUE"
export BTOP_MEM_END="$TOKYO_NIGHT_PURPLE"

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

# Function to display the color palette
tokyo_night_palette() {
    echo "Tokyo Night Color Palette:"
    echo ""
    echo "Base Colors:"
    echo "  Background:    $TOKYO_NIGHT_BG"
    echo "  Foreground:    $TOKYO_NIGHT_FG"
    echo "  Highlight:     $TOKYO_NIGHT_BG_HIGHLIGHT"
    echo ""
    echo "Primary Colors:"
    echo "  Red:           $TOKYO_NIGHT_RED"
    echo "  Orange:        $TOKYO_NIGHT_ORANGE"
    echo "  Yellow:        $TOKYO_NIGHT_YELLOW"
    echo "  Green:         $TOKYO_NIGHT_GREEN"
    echo "  Blue:          $TOKYO_NIGHT_BLUE"
    echo "  Cyan:          $TOKYO_NIGHT_CYAN"
    echo "  Purple:        $TOKYO_NIGHT_PURPLE"
    echo "  Magenta:       $TOKYO_NIGHT_MAGENTA"
    echo ""
    echo "Neutral Colors:"
    echo "  Gray:          $TOKYO_NIGHT_GRAY"
    echo "  Gray Dark:     $TOKYO_NIGHT_GRAY_DARK"
    echo "  Gray Light:    $TOKYO_NIGHT_GRAY_LIGHT"
}

# Function to test color support in terminal
tokyo_night_test() {
    echo "Testing Tokyo Night colors in terminal:"
    echo ""
    
    # Test basic colors
    for color in RED ORANGE YELLOW GREEN BLUE CYAN PURPLE; do
        var_name="TOKYO_NIGHT_$color"
        color_code="${!var_name}"
        printf "%-10s: \033[38;2;%d;%d;%dm■■■■■\033[0m %s\n" \
            "$color" \
            $((16#${color_code:1:2})) \
            $((16#${color_code:3:2})) \
            $((16#${color_code:5:2})) \
            "$color_code"
    done
    
    echo ""
    echo "If you see colored squares above, your terminal supports Tokyo Night colors!"
}

# Function to export all Tokyo Night colors to environment
tokyo_night_export() {
    # Export all TOKYO_NIGHT_* variables
    set | grep '^TOKYO_NIGHT_' | while IFS='=' read -r name value; do
        export "$name=$value"
    done
    
    # Export application-specific mappings
    set | grep -E '^(ALACRITTY|TMUX|GIT|FZF|STARSHIP|BTOP)_' | while IFS='=' read -r name value; do
        export "$name=$value"
    done
}

# ==============================================================================
# AUTO-EXPORT ON SOURCE
# ==============================================================================

# Automatically export all variables when this file is sourced
tokyo_night_export

# Add alias for easy access
alias tn-palette='tokyo_night_palette'
alias tn-test='tokyo_night_test'