# Btop Configuration

System resource monitor with Tokyo Night theme.

## Features

- **Tokyo Night theme** with custom color palette
- **Modern system monitoring** for CPU, memory, network, processes
- **Beautiful graphs** with braille characters
- **Detailed process information** with tree view
- **Battery monitoring** for laptops

## Installation

```bash
# Apply configuration via stow
cd ~/dotfiles
just stow-apply

# Or manually
stow -d packages -t ~ btop
```

## Structure

```
btop/
└── .config/
    └── btop/
        ├── btop.conf           # Main configuration
        └── themes/
            └── tokyo-night.theme  # Custom Tokyo Night theme
```

## Tokyo Night Theme

### Color Palette
- **Background**: `#1a1b26` (dark blue-black)
- **Foreground**: `#a9b1d6` (light blue-gray)
- **Highlights**: `#7aa2f7` (bright blue)
- **CPU**: Green to red gradient
- **Memory**: Blue to purple gradient
- **Network**: Cyan to blue gradient
- **Processes**: Green to red by usage

### Visual Features
- Dark background with Tokyo Night colors
- Gradient colors for different metrics
- Consistent with terminal and editor themes
- High contrast for readability

## Configuration

### Display Options
- **True color**: Enabled for full color range
- **UTF-8**: Forced for proper character display
- **Rounded corners**: Modern box appearance
- **Braille graphs**: High-resolution graph display
- **Detailed processes**: Shows full command lines

### Monitoring Settings
- **Update interval**: 2000ms for smooth updates
- **Process details**: Shows command arguments
- **Memory graphs**: Visual memory representation
- **Tree view**: Hierarchical process display
- **Battery stats**: Shows laptop battery info

### Performance
- **Background updates**: Maintains UI responsiveness
- **Optimized refresh**: Balances accuracy and performance
- **Physical disks only**: Filters out virtual filesystems

## Usage

### Basic Navigation
- **Arrow keys**: Navigate between sections
- **Tab**: Switch between boxes
- **q**: Quit btop
- **Space**: Pause/resume updates
- **+/-**: Increase/decrease update speed

### Process Management
- **t**: Toggle tree view
- **r**: Reverse sort order
- **c**: Sort by CPU usage
- **m**: Sort by memory usage
- **p**: Sort by PID
- **Enter**: Show process details

### View Options
- **1-4**: Show/hide individual boxes
- **h**: Toggle help
- **ESC**: Close menus/details
- **F2**: Options menu
- **F1**: Help screen

## Monitoring Features

### CPU Monitoring
- Per-core usage visualization
- Temperature monitoring (if available)
- Load averages
- CPU frequency information

### Memory Monitoring
- RAM usage with detailed breakdown
- Swap usage monitoring
- Available/cached/buffer memory
- Memory pressure indicators

### Network Monitoring
- Upload/download speeds
- Real-time network activity
- Interface-specific statistics
- Bandwidth utilization graphs

### Process Monitoring
- Detailed process list with filtering
- CPU and memory usage per process
- Process tree with parent-child relationships
- Command line arguments display

## Integration

### Terminal Integration
- Works in any terminal with 256+ color support
- Respects terminal size and resizing
- Proper Unicode character support
- Compatible with tmux sessions

### System Integration
- Monitors all system resources
- Works with various Linux distributions
- Compatible with containers and VMs
- Supports modern CPU architectures

## Customization

### Theme Switching
Switch to default themes:
```bash
# Edit ~/.config/btop/btop.conf
color_theme = "Default"
# or
color_theme = "TTY"
```

### Custom Settings
Modify configuration in `~/.config/btop/btop.conf`:
```ini
# Update interval (milliseconds)
update_ms = 1000

# Show temperature in Fahrenheit
temp_scale = "fahrenheit"

# Enable vim-like navigation
vim_keys = True
```

### Box Layout
Customize which boxes to show:
```ini
# Show only CPU and memory
shown_boxes = "cpu mem"

# Show all boxes
shown_boxes = "cpu mem net proc"
```

## Performance Tips

### System Impact
- Lightweight monitoring with minimal overhead
- Adjustable update intervals for different needs
- Efficient memory usage
- Low CPU impact during monitoring

### Optimization
- Increase update interval for battery saving
- Disable unused boxes for better performance
- Use tree view sparingly for large process lists
- Filter processes when needed

## Troubleshooting

### Theme Not Loading
Verify theme file exists:
```bash
ls ~/.config/btop/themes/tokyo-night.theme
```

Check configuration:
```bash
grep color_theme ~/.config/btop/btop.conf
```

### Colors Not Showing
Check terminal color support:
```bash
echo $TERM
btop --help  # Check for color support
```

### Performance Issues
Adjust update interval:
```bash
# Edit btop.conf
update_ms = 3000  # Slower updates
```

### Missing Information
Ensure proper permissions:
```bash
# Check if btop can access system info
btop --debug
```

## Resources

- [Btop++ Documentation](https://github.com/aristocratos/btop)
- [Theme Development](https://github.com/aristocratos/btop#themes)
- [Tokyo Night Colors](https://github.com/enkia/tokyo-night-vscode-theme)