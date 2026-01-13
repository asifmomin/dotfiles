# Claude Code Configuration

Configuration files for Claude Code (Anthropic's CLI tool) managed via stow.

## Features

- **Stow-managed** config files symlinked to `~/.claude/`
- **Custom statusline** with Tokyo Night colors matching starship prompt
- **MCP server** configuration for Playwright integration
- **Global instructions** in CLAUDE.md
- **Custom commands** for extended workflows

## Installation

```bash
# Apply configuration via stow
cd ~/dotfiles
just stow-apply

# Or manually
stow -d packages -t ~ claude-code
```

## Structure

```
claude-code/
└── .claude/
    ├── .mcp.json           # MCP servers configuration
    ├── CLAUDE.md           # Global instructions for Claude
    ├── settings.json       # Settings, plugins, and hooks
    ├── statusline.sh       # Custom status line script
    └── commands/
        └── global/
            └── explore/
                └── interview.md    # /global:explore:interview command
```

## Files Overview

### settings.json

Main configuration file containing:

- **statusLine**: Custom status line using `statusline.sh`
- **enabledPlugins**: Currently enabled plugins
  - `writing-elements@the-construct`
  - `document-skills@anthropic-agent-skills`
  - `beads@beads-marketplace`
- **hooks**: Notification hooks for permission prompts and input requests

### CLAUDE.md

Global instructions that apply to all Claude Code sessions:

- Document reading policy for large files
- Custom behaviors and preferences

### .mcp.json

MCP (Model Context Protocol) server configuration:

- Playwright server for browser automation

### statusline.sh

Custom status line script matching the starship prompt:

- Tokyo Night color scheme
- Shows current directory (repo root in green, path in cyan)
- Git branch in italic blue
- Git status indicators (staged, modified, untracked)

## Commands

### /global:explore:interview

Interview command for refining plans into specifications.

**Usage:**
```
/global:explore:interview [plan-file]
```

**Features:**
- Reads plan file or asks for requirements
- Conducts in-depth technical interview
- Covers implementation, UX, risks, tradeoffs
- Generates comprehensive specification document

## Plugins

Plugins are installed from marketplaces and managed by Claude Code. The `enabledPlugins` in settings.json declares which plugins should be active.

**Currently enabled:**
- `writing-elements` - Writing style tools
- `document-skills` - Document manipulation skills
- `beads` - Issue tracking integration

**Note:** Plugin files are cached in `~/.claude/plugins/cache/` and are not managed by dotfiles.

## Customization

### Adding Commands

Create new commands in `commands/` directory:

```
commands/<namespace>/<category>/<command>.md
```

Command files use frontmatter for metadata:

```markdown
---
description: Short description
argument-hint: [optional-args]
model: opus|sonnet|haiku
---

# Command Title

Your prompt instructions here...
```

### Modifying Settings

Edit `settings.json` to:
- Enable/disable plugins
- Add notification hooks
- Change status line configuration

### Global Instructions

Edit `CLAUDE.md` to add instructions that apply to all sessions.

## Files Not Managed

These runtime files remain in `~/.claude/` and are not tracked:

- `history.jsonl` - Conversation history
- `cache/` - Various caches
- `plugins/` - Installed plugin files
- `projects/` - Project-specific settings
- `todos/` - Todo list state
- Other runtime directories

## Integration

### Status Line

The status line integrates with the Tokyo Night theme used across:
- Starship prompt
- Neovim
- Tmux
- Alacritty

### Notification Hooks

macOS notifications via `terminal-notifier` for:
- Permission prompts
- Input requests
- MCP tool dialogs

## Troubleshooting

### Symlinks Not Working

Verify symlinks are correct:
```bash
ls -la ~/.claude/ | grep -E '(settings|CLAUDE|mcp|statusline)'
```

Restow if needed:
```bash
just stow-restow
```

### Status Line Not Showing

Check if statusline.sh is executable:
```bash
ls -la ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh  # if needed
```

### Plugins Not Loading

Plugins are installed on first use. If missing:
1. Check `enabledPlugins` in settings.json
2. Restart Claude Code to trigger installation

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [MCP Protocol](https://modelcontextprotocol.io/)
- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme)
