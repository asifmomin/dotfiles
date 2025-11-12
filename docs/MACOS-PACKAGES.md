# macOS-Specific Packages

> Documentation for tools and applications that are only installed on macOS

## Overview

This dotfiles configuration includes several macOS-specific packages that enhance productivity and provide GNU compatibility. These packages are automatically installed during `just bootstrap` or `just install-packages` on macOS systems.

## GUI Applications

### Visual Studio Code
**Type:** Code Editor
**Installation:** `brew install --cask visual-studio-code`

Microsoft's powerful, extensible code editor with rich ecosystem of extensions.

**Key Features:**
- Built-in Git integration
- Extensive language support
- Integrated terminal
- Remote development (SSH, containers, WSL)
- IntelliSense code completion

**Configuration:**
- Settings sync enabled via GitHub/Microsoft account
- Complements Neovim for when GUI is preferred
- Extensions managed separately from dotfiles

**Quick Launch:**
```bash
code .                    # Open current directory
code ~/path/to/project    # Open specific project
```

### Obsidian
**Type:** Knowledge Management
**Installation:** `brew install --cask obsidian`

Markdown-based knowledge base and note-taking application.

**Key Features:**
- Local-first (your notes stay on your machine)
- Markdown-native with live preview
- Graph view for connected thoughts
- Plugins and themes ecosystem
- Sync across devices (optional paid feature)

**Use Cases:**
- Personal knowledge management
- Project documentation
- Daily notes and journaling
- Research and learning

### Rectangle
**Type:** Window Management
**Installation:** `brew install --cask rectangle`

Keyboard-driven window manager for macOS (free alternative to Magnet/Divvy).

**Key Features:**
- Snap windows to screen edges/corners
- Keyboard shortcuts for all actions
- Multiple display support
- Remembers window positions

**Default Shortcuts:**
```bash
Ctrl + Option + Left/Right   # Half screen
Ctrl + Option + Up           # Maximize
Ctrl + Option + Down         # Restore
Ctrl + Option + U/I/J/K      # Corners
Ctrl + Option + C            # Center
Ctrl + Option + Enter        # Fullscreen
```

**Configuration:**
- Launches at startup (configure in app)
- Customize shortcuts in Rectangle preferences
- Not managed by dotfiles (user-specific preferences)

### Flycut
**Type:** Clipboard Manager
**Installation:** `brew install --cask flycut`

Lightweight clipboard history manager for macOS.

**Key Features:**
- Remembers clipboard history (up to 99 items)
- Quick access via keyboard shortcut
- Text-only (no images/files)
- Minimal and fast
- Open source

**Default Shortcut:**
```bash
Cmd + Shift + V    # Open clipboard history
```

**Configuration:**
- Launches at startup (configure in app)
- Set history size in preferences
- Customize activation shortcut

**Tips:**
- Search clipboard history by typing
- Navigate with arrow keys
- Press Enter to paste selected item

### SuperWhisper
**Type:** Voice-to-Text
**Installation:** `brew install --cask superwhisper`

AI-powered voice transcription application for macOS.

**Key Features:**
- High-quality voice-to-text transcription
- System-wide hotkey activation
- Fast and accurate speech recognition
- Privacy-focused (processes locally)

**Use Cases:**
- Dictating notes and emails
- Voice-driven writing
- Accessibility support
- Quick voice memos

**Configuration:**
- Configure global hotkey in app preferences
- Adjust transcription settings as needed
- Check app documentation for advanced features

### pngpaste
**Type:** Clipboard Utility
**Installation:** `brew install pngpaste`

Command-line tool to paste PNG images from clipboard to files.

**Key Features:**
- Paste clipboard images directly as PNG files
- Command-line interface for automation
- Integrates with scripts and workflows
- Works with screenshots and copied images

**Use Cases:**
- Save screenshots programmatically
- Automate image workflows
- Quick image extraction from clipboard
- Integration with note-taking and documentation tools

**Usage:**
```bash
# Paste clipboard image to file
pngpaste screenshot.png

# With timestamp
pngpaste "screenshot-$(date +%Y%m%d-%H%M%S).png"

# In scripts
if pngpaste /tmp/clipboard.png 2>/dev/null; then
    echo "Image saved"
else
    echo "No image in clipboard"
fi
```

**Tips:**
- Use with keyboard shortcuts (via tools like Alfred or custom scripts)
- Combine with screenshot utilities for enhanced workflows
- Great for quickly saving images while documenting

## GNU Utilities

macOS ships with BSD versions of common Unix utilities, which have different flags and behavior than GNU versions. These packages provide GNU-compatible versions for cross-platform script compatibility.

### Core Utilities (coreutils)
**Installation:** `brew install coreutils`

GNU core utilities including ls, cat, cp, mv, rm, etc.

**Installed Tools:**
- ls, cat, cp, mv, rm, mkdir, touch
- chmod, chown, ln, pwd, echo
- sort, uniq, head, tail, wc
- And 100+ more utilities

**Usage:**
- Installed with 'g' prefix: `gls`, `gcat`, `gcp`
- Add to PATH for GNU defaults (not recommended for macOS)
- Use explicitly in scripts for GNU behavior

**Why Needed:**
- BSD ls doesn't support `--color`
- Different date formats in scripts
- Cross-platform shell script compatibility

### GNU sed
**Installation:** `brew install gnu-sed`

Stream editor with extended regex support.

**Usage:**
```bash
gsed 's/foo/bar/g' file.txt   # GNU sed
sed 's/foo/bar/g' file.txt    # BSD sed (macOS default)
```

**Differences:**
- `-i` flag works differently (BSD requires extension, GNU optional)
- Regex syntax differences
- Better compatibility with Linux sed scripts

### GNU Find (findutils)
**Installation:** `brew install findutils`

File search utilities with GNU extensions.

**Usage:**
```bash
gfind . -name "*.txt"         # GNU find
find . -name "*.txt"          # BSD find
```

**Why Needed:**
- `-printf` option (not in BSD find)
- Different default behavior
- Cross-platform script compatibility

### GNU grep
**Installation:** `brew install grep`

Pattern matching with extended features.

**Usage:**
```bash
ggrep -r "pattern" .          # GNU grep
grep -r "pattern" .           # BSD grep
```

**Note:** This dotfiles uses `ripgrep` (rg) as the primary grep replacement, which is faster and more user-friendly than both GNU and BSD grep.

### GNU awk (gawk)
**Installation:** `brew install gawk`

Text processing language with GNU extensions.

**Usage:**
```bash
gawk '{print $1}' file.txt    # GNU awk
awk '{print $1}' file.txt     # BSD awk
```

### GNU tar
**Installation:** `brew install gnu-tar`

Archive utility with GNU features.

**Usage:**
```bash
gtar -czf archive.tar.gz dir  # GNU tar
tar -czf archive.tar.gz dir   # BSD tar
```

**Differences:**
- Extended attributes handling
- Compression options
- Archive format compatibility

## Installation

### Automatic (Recommended)
All macOS-specific packages are installed automatically:
```bash
just bootstrap          # Full setup
just install-packages   # Packages only
```

### Manual Installation
Install specific packages:
```bash
# GUI applications
brew install --cask visual-studio-code obsidian rectangle flycut superwhisper

# GNU utilities
brew install coreutils gnu-sed findutils grep gawk gnu-tar
```

## Verification

Check if macOS-specific tools are installed:
```bash
just doctor             # Comprehensive health check

# Or check manually
which code              # VS Code CLI
which gls               # GNU ls
which gsed              # GNU sed
```

## Platform Detection

The Brewfile uses Homebrew's OS detection:
```ruby
if OS.mac?
  cask "visual-studio-code"
  brew "coreutils"
end
```

This ensures these packages are only installed on macOS systems, not on Linux or WSL.

## Customization

### Adding macOS-Specific Packages

To add new macOS-only packages:

1. Edit `platform/brew/Brewfile`
2. Add within the `if OS.mac?` block:
   ```ruby
   if OS.mac?
     cask "new-gui-app"      # GUI applications
     brew "new-cli-tool"      # Command-line tools
   end
   ```
3. Run `just install-packages`
4. Update this documentation

### Removing Packages

To remove packages you don't need:

1. Edit `platform/brew/Brewfile` and remove the line
2. Run `brew uninstall --cask <package>` or `brew uninstall <package>`
3. Run `just install-packages` to verify

## Cross-Platform Considerations

### Scripts
When writing cross-platform scripts:
```bash
# Use platform detection
source lib/platform.sh

if is_macos; then
    # Use GNU utilities explicitly
    gls --color=auto
else
    # Linux has GNU by default
    ls --color=auto
fi
```

### Aliases
Shell aliases handle GNU utilities transparently:
- `ls` → `eza` (works everywhere)
- `cat` → `bat` (works everywhere)
- See [Shell Aliases Reference](../packages/shell/ALIASES.md)

## FAQ

**Q: Why install GNU utilities if macOS has BSD versions?**
A: For cross-platform script compatibility. Many scripts written for Linux expect GNU behavior.

**Q: Should I replace BSD utilities with GNU versions?**
A: Generally no. Keep BSD as default, use GNU explicitly with 'g' prefix when needed.

**Q: Can I use these configs on Linux without the macOS apps?**
A: Yes. The `if OS.mac?` conditional prevents installing these on Linux/WSL.

**Q: Why aren't GUI app configs in dotfiles?**
A: GUI apps typically store preferences in `~/Library/` with opaque formats. We install them but don't manage their configs.

**Q: How do I backup GUI app settings?**
A: Use each app's built-in sync (VS Code Sync, Obsidian Sync) or manually backup `~/Library/Application Support/<app>`.

## Related Documentation

- [Installation Instructions](./instructions.md) - Full setup guide
- [Quick Start Guide](./QUICKSTART.md) - Get running fast
- [Shell Aliases](../packages/shell/ALIASES.md) - Command shortcuts
- [Philosophy](./PHILOSOPHY.md) - Design principles

## See Also

- [Homebrew Cask Documentation](https://github.com/Homebrew/homebrew-cask)
- [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)
- [BSD vs GNU Differences](https://avi.im/blag/2021/homebrew-bsd-gnu/)
