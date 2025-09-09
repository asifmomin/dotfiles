# Neovim Configuration (Omarchy Style)

Ultra-minimal LazyVim configuration following Omarchy's philosophy of trusting defaults.

## Features

- **Pure LazyVim** with minimal customization
- **Tokyo Night** colorscheme
- **Transparent backgrounds** for clean aesthetic
- **Disabled animations** for better performance
- **Neo-tree** file explorer

## Installation

```bash
# Apply configuration via stow
cd ~/dotfiles
just stow-apply

# Or manually
stow -d packages -t ~ neovim
```

## Structure

```
neovim/
└── .config/
    └── nvim/
        ├── lazyvim.json                      # LazyVim extras configuration
        ├── lua/
        │   └── plugins/
        │       ├── theme.lua                 # Tokyo Night theme setup
        │       └── snacks-animated-scrolling-off.lua  # Disable animations
        └── plugin/
            └── after/
                └── transparency.lua          # Transparent backgrounds
```

## Philosophy

Following Omarchy's approach:
- **Trust LazyVim defaults** - minimal customization
- **Performance first** - disable unnecessary animations
- **Clean aesthetics** - transparent backgrounds
- **Essential only** - just theme + transparency + neo-tree

## Configuration Files

### LazyVim Extras (`lazyvim.json`)
- Enables neo-tree file explorer
- Uses LazyVim's curated plugin selection

### Theme (`lua/plugins/theme.lua`)
- Sets Tokyo Night as the colorscheme
- No additional theme customization

### Performance (`lua/plugins/snacks-animated-scrolling-off.lua`)
- Disables scroll animations for better performance
- Keeps UI responsive

### Transparency (`plugin/after/transparency.lua`)
- Makes all backgrounds transparent
- Covers editor, floats, notifications, file explorer
- Creates clean, minimal appearance

## Key Features

### LazyVim Defaults
- Modern plugin management with lazy.nvim
- Sensible defaults for editing
- LSP configuration out of the box
- Telescope fuzzy finder
- Git integration with gitsigns
- Auto-completion with nvim-cmp

### Tokyo Night Theme
- Consistent with shell and terminal theming
- Multiple variants available
- Good contrast and readability

### Transparent UI
- All backgrounds set to transparent
- Clean integration with terminal
- Minimal visual distraction

## Usage

LazyVim provides these key bindings out of the box:

#### Leader Key: `<Space>`

#### Essential Commands
- `<leader>e` - Toggle file explorer (neo-tree)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Switch buffers
- `<leader>fr` - Recent files

#### LSP (works automatically)
- `gd` - Go to definition
- `gr` - Go to references  
- `K` - Hover documentation
- `<leader>ca` - Code actions

#### Git Integration
- `]h` / `[h` - Next/previous hunk
- `<leader>gg` - Git status

## Customization

### Adding Personal Config
For personal tweaks, create additional files in `lua/plugins/`:

```lua
-- lua/plugins/personal.lua
return {
  -- Add your minimal customizations here
}
```

### Changing Theme Variant
Edit `lua/plugins/theme.lua`:

```lua
return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "storm", -- night, storm, day, moon
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
```

### Disabling Transparency
Comment out or remove `plugin/after/transparency.lua` to use solid backgrounds.

## Why This Approach?

Omarchy's philosophy emphasizes:
1. **Trust the experts** - LazyVim maintainers know best
2. **Less is more** - minimal configuration reduces bugs
3. **Performance matters** - fewer features = faster startup
4. **Aesthetics** - transparency creates clean look
5. **Maintenance** - less code to maintain

This results in a robust, fast, and beautiful Neovim setup with minimal effort.

## Resources

- [LazyVim Documentation](https://lazyvim.github.io/)
- [Tokyo Night Theme](https://github.com/folke/tokyonight.nvim)
- [Omarchy](https://github.com/2KAbhishek/omarchy)