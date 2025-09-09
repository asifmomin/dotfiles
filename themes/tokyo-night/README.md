# Tokyo Night Color Palette

Unified color definitions for consistent theming across all dotfiles applications.

## Overview

This directory contains the master Tokyo Night color palette used throughout all dotfiles packages. It ensures color consistency across terminal, editor, shell, and all other applications.

## Files

- **`colors.sh`** - Shell variables with all Tokyo Night colors and utility functions
- **`README.md`** - This documentation

## Color Palette

### Base Colors
- **Background**: `#1a1b26` (dark blue-black)
- **Foreground**: `#a9b1d6` (light blue-gray)
- **Highlight**: `#283457` (selection background)

### Primary Colors
- **Red**: `#f7768e` (errors, deletion)
- **Orange**: `#ff9e64` (warnings, modifications)
- **Yellow**: `#e0af68` (caution, information)
- **Green**: `#9ece6a` (success, additions)
- **Blue**: `#7aa2f7` (primary, keywords)
- **Cyan**: `#7dcfff` (secondary, strings)
- **Purple**: `#bb9af7` (accent, functions)
- **Magenta**: `#c0caf5` (variables, constants)

### Neutral Colors
- **Gray**: `#565f89` (comments, disabled)
- **Gray Dark**: `#414868` (borders, separators)
- **Gray Light**: `#737aa2` (secondary text)

## Usage

### In Shell Scripts
```bash
# Source the color definitions
source ~/dotfiles/themes/tokyo-night/colors.sh

# Use the colors
echo "Error: ${TOKYO_NIGHT_RED}Something went wrong${TOKYO_NIGHT_FG}"
```

### In Configuration Files
```bash
# Get specific color for use in configs
ACCENT_COLOR=$(source ~/dotfiles/themes/tokyo-night/colors.sh && echo $TOKYO_NIGHT_BLUE)
```

### Utility Functions
```bash
# Display the full color palette
tn-palette

# Test color support in your terminal
tn-test

# View all available color variables
tokyo_night_export && env | grep TOKYO_NIGHT
```

## Application Integration

### Current Applications Using This Palette
1. **Alacritty** - Terminal colors and themes
2. **Tmux** - Status line and pane borders
3. **Git** - Diff colors and branch highlighting
4. **Starship** - Prompt colors and git status
5. **Neovim** - Editor theme and UI elements
6. **Btop** - System monitor colors and graphs
7. **FZF** - Fuzzy finder interface colors
8. **Bat** - Syntax highlighting theme

### Application-Specific Mappings
The color file includes pre-defined mappings for each application:
- `ALACRITTY_*` - Terminal emulator colors
- `TMUX_*` - Terminal multiplexer colors
- `GIT_*` - Version control colors
- `STARSHIP_*` - Shell prompt colors
- `BTOP_*` - System monitor colors
- `FZF_*` - Fuzzy finder colors

## Color Theory

### Tokyo Night Philosophy
- **Dark background** reduces eye strain
- **Blue-based palette** provides calm, professional appearance
- **High contrast** ensures readability
- **Semantic colors** (red=error, green=success) follow conventions
- **Consistent saturation** creates visual harmony

### Accessibility
- WCAG AA compliant contrast ratios
- Colorblind-friendly palette
- High contrast options available
- Clear distinction between semantic states

## Customization

### Creating Variants
To create a variant (e.g., "Tokyo Night Storm"):

1. Copy `colors.sh` to `colors-storm.sh`
2. Adjust the base colors:
   ```bash
   export TOKYO_NIGHT_BG="#24283b"  # Lighter background
   export TOKYO_NIGHT_FG="#a9b1d6"  # Same foreground
   ```
3. Update application configs to source the new file

### Adding New Applications
To add Tokyo Night support to a new application:

1. Add application-specific color mappings to `colors.sh`:
   ```bash
   export NEWAPP_BG="$TOKYO_NIGHT_BG"
   export NEWAPP_ACCENT="$TOKYO_NIGHT_BLUE"
   ```

2. Create the application package using these variables
3. Source the colors file in the application's config

### Override Colors
For personal color preferences, create `colors-local.sh`:
```bash
# Source the main palette
source ~/dotfiles/themes/tokyo-night/colors.sh

# Override specific colors
export TOKYO_NIGHT_BLUE="#89b4fa"  # Custom blue
export TMUX_ACTIVE="$TOKYO_NIGHT_BLUE"  # Update derived colors
```

## Color Testing

### Terminal Support
Test if your terminal supports Tokyo Night colors:
```bash
tn-test
```

This will display colored squares if your terminal supports 24-bit color.

### Color Accuracy
Different terminals may render colors slightly differently. For best results:
- Use a terminal with true color (24-bit) support
- Ensure terminal color profile is set to sRGB
- Disable any terminal color adjustments

## Integration Examples

### Shell Prompt
```bash
# In .zshrc or .bashrc
source ~/dotfiles/themes/tokyo-night/colors.sh
export PS1="\[${TOKYO_NIGHT_GREEN}\]\u\[${TOKYO_NIGHT_FG}\]@\[${TOKYO_NIGHT_BLUE}\]\h\[${TOKYO_NIGHT_FG}\]:\[${TOKYO_NIGHT_CYAN}\]\w\[${TOKYO_NIGHT_FG}\]$ "
```

### Configuration Generation
```bash
# Generate config files with Tokyo Night colors
source ~/dotfiles/themes/tokyo-night/colors.sh
sed "s/{{BG_COLOR}}/${TOKYO_NIGHT_BG}/g" template.conf > app.conf
```

## Resources

- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme) - Original VS Code theme
- [Color Theory Guide](https://en.wikipedia.org/wiki/Color_theory)
- [WCAG Contrast Guidelines](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)