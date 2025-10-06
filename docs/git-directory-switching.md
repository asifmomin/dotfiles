# Git Directory-Based Identity Switching

> Automatically switch Git identity based on project directory

Automatic Git configuration switching based on project location for seamless work/personal repository management.

## Quick Setup (2 minutes)

```bash
# 1. Create directories
mkdir -p ~/work ~/per

# 2. Configure work identity
git config --file ~/.config/git/config-work user.name "Work Name"
git config --file ~/.config/git/config-work user.email "work@company.com"

# 3. Configure personal identity
git config --file ~/.config/git/config-personal user.name "Personal Name"
git config --file ~/.config/git/config-personal user.email "personal@email.com"

# 4. Test it
cd ~/work && git config user.email  # Shows work email
cd ~/per && git config user.email   # Shows personal email
```

**That's it!** Now `~/work/*` uses work identity, `~/per/*` uses personal identity.

---

## Detailed Guide

## Overview

This dotfiles setup includes an advanced Git configuration that automatically switches your Git identity (name, email, and preferences) based on the directory where your repository is located. This eliminates the need to manually configure Git for each project and prevents accidentally committing with the wrong identity.

## How It Works

Git's `includeIf` directive allows conditional loading of configuration files based on the repository path. Our setup uses this to automatically apply different configurations:

- **`~/work/`** - Work repositories use work identity
- **`~/per/`** - Personal repositories use personal identity  
- **Other locations** - Fall back to global configuration

## Directory Structure

```
~/
├── work/                    # Work projects
│   ├── company-project/     # Uses work identity
│   ├── client-website/      # Uses work identity
│   └── internal-tool/       # Uses work identity
├── per/                     # Personal projects
│   ├── my-blog/            # Uses personal identity
│   ├── side-project/       # Uses personal identity
│   └── dotfiles/           # Uses personal identity
└── other/                  # Other projects
    └── open-source/        # Uses global identity
```

## Configuration Files

### Main Configuration
**`~/.config/git/config`** - Contains shared settings and conditional includes:

```ini
[user]
    # Default/global user (fallback)
    name = "Default Name"
    email = "default@example.com"

# Conditional includes
[includeIf "gitdir:~/work/"]
    path = ~/.config/git/config-work

[includeIf "gitdir:~/per/"]
    path = ~/.config/git/config-personal

# Shared settings (aliases, colors, etc.)
[core]
    editor = nvim
    pager = bat --style=plain --paging=always
```

### Work Configuration
**`~/.config/git/config-work`** - Work-specific settings:

```ini
[user]
    name = "John Doe"
    email = "john.doe@company.com"

[alias]
    work-init = "!git init && git config user.name 'John Doe'"
    
[pull]
    rebase = false  # Work prefers merge commits
```

### Personal Configuration
**`~/.config/git/config-personal`** - Personal-specific settings:

```ini
[user]
    name = "John Smith"
    email = "john@personal.com"

[alias]
    personal-init = "!git init && git config user.name 'John Smith'"
    
[pull]
    rebase = true  # Personal prefers clean history
```

## Setup Guide

### 1. Initial Setup

The configuration files are automatically installed via stow:

```bash
cd ~/dotfiles
just stow-apply
```

### 2. Configure Work Identity

```bash
# Create work directory
mkdir -p ~/work

# Set work identity
git config --file ~/.config/git/config-work user.name "Your Work Name"
git config --file ~/.config/git/config-work user.email "you@company.com"
```

### 3. Configure Personal Identity

```bash
# Create personal directory
mkdir -p ~/per

# Set personal identity
git config --file ~/.config/git/config-personal user.name "Your Personal Name"
git config --file ~/.config/git/config-personal user.email "you@personal.com"
```

### 4. Set Global Fallback

```bash
# For repositories outside work/per directories
git config --global user.name "Your Default Name"
git config --global user.email "you@default.com"
```

## Testing the Configuration

### Test Work Configuration

```bash
cd ~/work
mkdir test-repo && cd test-repo
git init

# Verify work identity
git config user.name     # Should show work name
git config user.email    # Should show work email

# Clean up
cd .. && rm -rf test-repo
```

### Test Personal Configuration

```bash
cd ~/per
mkdir test-repo && cd test-repo
git init

# Verify personal identity
git config user.name     # Should show personal name
git config user.email    # Should show personal email

# Clean up
cd .. && rm -rf test-repo
```

### Test Global Fallback

```bash
cd ~/other  # Or any directory outside work/per
mkdir test-repo && cd test-repo
git init

# Verify global identity
git config user.name     # Should show global name
git config user.email    # Should show global email

# Clean up
cd .. && rm -rf test-repo
```

## Advanced Features

### Different SSH Keys

Configure different SSH keys for work and personal repositories:

```bash
# Work SSH key
git config --file ~/.config/git/config-work core.sshCommand "ssh -i ~/.ssh/id_work"

# Personal SSH key  
git config --file ~/.config/git/config-personal core.sshCommand "ssh -i ~/.ssh/id_personal"
```

### Different Remote URLs

Configure different remote URL patterns:

```bash
# Work uses enterprise GitHub
echo '[url "git@github-work:"]' >> ~/.config/git/config-work
echo '    insteadOf = "https://github.company.com/"' >> ~/.config/git/config-work

# Personal uses standard GitHub
echo '[url "git@github.com:"]' >> ~/.config/git/config-personal  
echo '    insteadOf = "https://github.com/"' >> ~/.config/git/config-personal
```

### Different Default Branches

Set different default branch names:

```bash
# Work uses 'main'
git config --file ~/.config/git/config-work init.defaultBranch main

# Personal uses 'master'
git config --file ~/.config/git/config-personal init.defaultBranch master
```

## Shell Integration

### Convenience Functions

Add these functions to your shell configuration (`~/.config/zsh/local.zsh`):

```bash
# Quick work project setup
work() {
    local project_name="$1"
    if [[ -z "$project_name" ]]; then
        echo "Usage: work <project-name>"
        return 1
    fi
    
    mkdir -p ~/work/"$project_name"
    cd ~/work/"$project_name"
    
    echo "Work directory created: $(pwd)"
    echo "Git identity: $(git config user.name) <$(git config user.email)>"
}

# Quick personal project setup  
personal() {
    local project_name="$1"
    if [[ -z "$project_name" ]]; then
        echo "Usage: personal <project-name>"
        return 1
    fi
    
    mkdir -p ~/per/"$project_name"
    cd ~/per/"$project_name"
    
    echo "Personal directory created: $(pwd)"
    echo "Git identity: $(git config user.name) <$(git config user.email)>"
}

# Check current git identity
gitid() {
    echo "Current Git identity:"
    echo "  Name:  $(git config user.name)"
    echo "  Email: $(git config user.email)"
    echo "  Dir:   $(pwd)"
}
```

### Usage Examples

```bash
# Create new work project
work new-website
# → Creates ~/work/new-website and shows work identity

# Create new personal project  
personal my-blog
# → Creates ~/per/my-blog and shows personal identity

# Check current identity
gitid
# → Shows current name, email, and directory
```

## Troubleshooting

### Identity Not Switching

1. **Check directory structure**:
   ```bash
   pwd  # Ensure you're in ~/work/ or ~/per/
   ```

2. **Verify configuration files exist**:
   ```bash
   ls ~/.config/git/config*
   # Should show: config, config-work, config-personal
   ```

3. **Test configuration loading**:
   ```bash
   git config --list --show-origin | grep user
   # Shows which file each setting comes from
   ```

### Configuration Not Loading

1. **Check Git version** (includeIf requires Git 2.13+):
   ```bash
   git --version
   ```

2. **Verify file syntax**:
   ```bash
   git config --file ~/.config/git/config-work --list
   git config --file ~/.config/git/config-personal --list
   ```

3. **Test conditional includes**:
   ```bash
   cd ~/work
   git config --list | grep includeIf
   ```

### Wrong Identity in Commits

If you've already made commits with the wrong identity:

```bash
# Change author of last commit
git commit --amend --author="Correct Name <correct@email.com>"

# Change author of multiple commits (interactive rebase)
git rebase -i HEAD~3  # For last 3 commits
# In editor, change 'pick' to 'edit' for commits to fix
# For each commit:
git commit --amend --author="Correct Name <correct@email.com>"
git rebase --continue
```

## Best Practices

### Directory Organization

1. **Consistent structure**:
   ```
   ~/work/
   ├── company-name/
   │   ├── project-1/
   │   └── project-2/
   └── client-name/
       └── client-project/
   
   ~/per/
   ├── websites/
   │   └── personal-blog/
   └── tools/
       └── dotfiles/
   ```

2. **Clear separation**: Never mix work and personal projects in the same directory tree.

3. **Backup configurations**: Keep your identity configurations in secrets management.

### Security Considerations

1. **Separate SSH keys**: Use different SSH keys for work and personal.

2. **Different GPG keys**: If using commit signing, use separate GPG keys.

3. **Audit commits**: Regularly check recent commits for correct identity:
   ```bash
   git log --oneline --format="%h %an <%ae> %s" -10
   ```

## Integration with Dotfiles

This directory-switching setup integrates seamlessly with the dotfiles system:

- **Automatic setup**: Configurations installed via `just stow-apply`
- **Tokyo Night theme**: All Git output uses consistent colors
- **Shell integration**: Works with Git aliases and Starship prompt
- **Cross-platform**: Works on macOS, Linux, and WSL

## Migration Guide

### From Manual Configuration

If you currently manually set Git config for each project:

1. **Identify current identities**:
   ```bash
   # In each project directory
   git config user.name
   git config user.email
   ```

2. **Move projects to appropriate directories**:
   ```bash
   # Move work projects
   mv ~/projects/work-project ~/work/
   
   # Move personal projects
   mv ~/projects/personal-project ~/per/
   ```

3. **Clear local configurations**:
   ```bash
   # In each moved project
   git config --unset user.name
   git config --unset user.email
   ```

### From Other Git Identity Tools

If using tools like `git-identity` or similar:

1. **Export current identities** to the new configuration files
2. **Test the new setup** thoroughly
3. **Remove old tools** once verified working
4. **Update any automation** to use the new directory structure

## Resources

- [Git Conditional Includes Documentation](https://git-scm.com/docs/git-config#_conditional_includes)
- [Git Configuration Documentation](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
- [SSH Key Management](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)