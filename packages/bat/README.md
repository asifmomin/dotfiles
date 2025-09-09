# Bat Configuration

Enhanced `cat` command with syntax highlighting and Tokyo Night theme.

## Features

- **Tokyo Night theme** via TwoDark (closest match)
- **Syntax highlighting** for 200+ languages
- **Line numbers** and git diff integration
- **Smart paging** for long files
- **File type detection** with custom mappings

## Installation

```bash
# Apply configuration via stow
cd ~/dotfiles
just stow-apply

# Or manually
stow -d packages -t ~ bat
```

## Structure

```
bat/
└── .config/
    └── bat/
        └── config      # Main configuration
```

## Configuration

### Theme
Uses `TwoDark` theme which closely matches Tokyo Night colors:
- Dark background with blue tones
- Syntax highlighting in Tokyo Night-compatible colors
- Good contrast for readability

### Display Options
- **Line numbers**: Always shown for reference
- **Git changes**: Shows added/modified/deleted lines
- **Headers**: Shows file names and language info
- **Auto-wrapping**: Long lines wrap automatically
- **Smart paging**: Uses pager for long files

### File Type Mappings
Custom syntax highlighting for:
- **Config files**: `.conf`, `.config` → INI syntax
- **Docker**: `Dockerfile*`, `docker-compose*.yml`
- **Environment**: `.env*` files → Bash syntax
- **Build files**: `justfile`, `Justfile` → Makefile syntax

## Usage

### Basic Commands
```bash
# View file with syntax highlighting
bat file.js

# View multiple files
bat *.py

# View with line numbers only
bat --style=numbers file.txt

# View without paging
bat --paging=never file.txt

# View specific line range
bat --line-range 1:50 file.txt
```

### Integration with Other Tools
```bash
# Use as pager for git
git config --global core.pager "bat --style=plain --paging=always"

# Use with find
find . -name "*.js" -exec bat {} \;

# Use with grep
grep -r "pattern" . | bat --language=grep
```

### Aliases (already in zsh config)
```bash
cat file.txt     # Actually runs: bat file.txt
less file.txt    # Actually runs: bat file.txt
```

## Theme Details

### TwoDark Theme Colors
- **Background**: Dark blue-black (similar to Tokyo Night)
- **Foreground**: Light blue-gray
- **Keywords**: Blue and purple tones
- **Strings**: Green tones
- **Comments**: Muted gray
- **Numbers**: Orange/yellow tones

### Syntax Support
Automatic detection for:
- **Programming**: JavaScript, Python, Rust, Go, Java, C++, etc.
- **Markup**: HTML, Markdown, XML, YAML, JSON
- **Config**: INI, TOML, Properties, Dotenv
- **Shell**: Bash, Zsh, Fish, PowerShell
- **Data**: CSV, SQL, Log files

## Advanced Usage

### Custom Themes
List available themes:
```bash
bat --list-themes
```

Preview themes:
```bash
bat --theme=Dracula file.txt
```

### Language Detection
List supported languages:
```bash
bat --list-languages
```

Force specific language:
```bash
bat --language=json file.txt
```

### Output Styles
Available styles:
- `auto`: Default with line numbers and git changes
- `plain`: No decorations
- `numbers`: Line numbers only
- `changes`: Git changes only
- `header`: File header only
- `grid`: Add grid lines

Combine styles:
```bash
bat --style=numbers,header file.txt
```

## Integration

### Shell Integration
Works seamlessly with zsh configuration:
- Aliased as `cat` command
- Used as pager for man pages
- Integrated with git for diff viewing

### Git Integration
Configured as git pager in git package:
- Syntax highlighted diffs
- Line numbers in git log
- Consistent theming

### Tmux Integration
Works within tmux sessions:
- Proper color support
- Respects terminal capabilities
- Consistent with tmux Tokyo Night theme

## Troubleshooting

### Colors Not Showing
Check terminal color support:
```bash
echo $TERM  # Should support 256 colors
bat --diagnostic
```

### Theme Issues
Verify theme availability:
```bash
bat --list-themes | grep TwoDark
```

### File Type Issues
Check language detection:
```bash
bat --language=help
```

## Performance

### Large Files
Bat handles large files efficiently:
- Lazy loading for paging
- Fast syntax highlighting
- Memory-efficient processing

### Startup Time
Optimized for quick startup:
- Cached syntax definitions
- Minimal configuration overhead
- Fast file type detection

## Resources

- [Bat Documentation](https://github.com/sharkdp/bat)
- [Syntax Highlighting Guide](https://github.com/sharkdp/bat#syntax-highlighting)
- [Theme Development](https://github.com/sharkdp/bat#adding-new-themes)