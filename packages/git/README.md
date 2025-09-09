# Git Configuration

Git configuration with Tokyo Night colors and XDG compliance.

## Features

- **XDG-compliant** configuration structure
- **Tokyo Night colors** for diff, status, and branch output
- **Comprehensive aliases** adapted from Omarchy
- **Modern defaults** with sensible settings
- **Global gitignore** for common file types

## Installation

```bash
# Apply configuration via stow
cd ~/dotfiles
just stow-apply

# Or manually
stow -d packages -t ~ git
```

## Structure

```
git/
├── .gitconfig              # Legacy shim (includes XDG config)
└── .config/
    └── git/
        ├── config          # Main configuration
        └── ignore          # Global gitignore
```

## Configuration Setup

After installation, set your identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Tokyo Night Colors

### Color Scheme
- **Current branch**: Cyan bold
- **Local branches**: Cyan
- **Remote branches**: Magenta
- **Added lines**: Green
- **Removed lines**: Red
- **Changed files**: Yellow
- **Untracked files**: Red

### Visual Features
- Colored output for all git commands
- Enhanced diff with conflict style
- Color-coded status output
- Syntax highlighting via bat pager

## Aliases

### Basic Shortcuts
```bash
git co <branch>     # checkout
git br              # branch
git ci              # commit
git st              # status
git a <file>        # add
git aa              # add all
```

### Commit Shortcuts
```bash
git cm "message"    # commit with message
git ca "message"    # commit all with message
git acm "message"   # add all and commit with message
git amend           # amend last commit
```

### Log and History
```bash
git l               # oneline log
git lg              # pretty graph log
git ll              # log with stats
git lol             # graph log
git lola            # graph log all branches
```

### Branch Management
```bash
git bd <branch>     # delete branch
git bdd <branch>    # force delete branch
git clean-branches  # delete merged branches
```

### Diff Shortcuts
```bash
git d               # diff working directory
git dc              # diff cached/staged
git ds              # diff stats
```

### Stash Operations
```bash
git sl              # stash list
git sa              # stash apply
git ss "message"    # stash save with message
```

### Push/Pull
```bash
git pu              # push
git puf             # push force with lease
git puu             # push and set upstream
```

### Reset Operations
```bash
git unstage <file>  # unstage file
git uncommit        # soft reset last commit
```

## Modern Git Features

### Default Settings
- Default branch: `main`
- Pull rebase: enabled
- Auto-setup remote on push
- Prune on fetch
- Patience diff algorithm
- Enhanced conflict resolution

### Integration
- **Editor**: Neovim for commit messages
- **Pager**: bat with syntax highlighting
- **SSH**: Prefers SSH over HTTPS for GitHub

## Global Gitignore

Automatically ignores common files across all repositories:
- OS files (`.DS_Store`, `Thumbs.db`, etc.)
- IDE files (`.vscode/`, `.idea/`, etc.)
- Language artifacts (`node_modules/`, `__pycache__/`, etc.)
- Temporary files (`*.tmp`, `*.log`, etc.)

## Advanced Features

### URL Rewriting
Automatically converts HTTPS GitHub URLs to SSH for authenticated access.

### Rerere
Reuse recorded resolution for merge conflicts.

### Auto-correct
Automatically corrects typos in git commands.

### Conflict Style
Enhanced diff3 conflict markers for better merge resolution.

## Customization

### Personal Overrides
Add personal settings to `~/.config/git/config.local`:

```bash
# ~/.config/git/config.local
[user]
    signingkey = your-gpg-key

[commit]
    gpgsign = true
```

Then include it in the main config:
```bash
# Add to ~/.config/git/config
[include]
    path = ~/.config/git/config.local
```

### Project-specific Settings
Use `.gitconfig` in project directories for project-specific settings.

## Integration with Other Tools

### Shell Integration
- Works with zsh aliases (`g`, `ga`, `gc`, etc.)
- Integrates with starship prompt for git status
- Compatible with modern CLI tools

### Editor Integration
- Neovim as default editor
- Proper syntax highlighting for commit messages
- LazyVim git integration support

## Common Workflows

### Feature Branch Workflow
```bash
git co -b feature/new-feature
# Make changes
git aa && git cm "Add new feature"
git puu
# Create PR, then after merge:
git co main && git pull && git clean-branches
```

### Quick Fixes
```bash
git acm "Fix typo"
git puf
```

### Interactive Staging
```bash
git add -p  # Stage hunks interactively
git ci      # Commit staged changes
```

## Troubleshooting

### Colors Not Showing
Check terminal color support:
```bash
git config --get color.ui  # Should be 'auto' or 'true'
```

### SSH Issues
Verify SSH key setup:
```bash
ssh -T git@github.com
```

### Aliases Not Working
Verify configuration:
```bash
git config --list | grep alias
```

## Resources

- [Git Documentation](https://git-scm.com/doc)
- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme)
- [Git Aliases Guide](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)