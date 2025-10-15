# Mise Configuration

Runtime version manager for programming languages and tools. Mise is a modern alternative to asdf, providing faster performance and better developer experience.

## Overview

This package provides global mise configuration for managing programming language versions.

**Official documentation:** https://mise.jdx.dev

## Installed by Default

- **Python 3.12 (LTS)** - Latest stable Python version

## Features

- **Automatic activation** - Mise is activated in shell startup (`.zshrc`)
- **Per-project versions** - Use `.mise.toml` or `.tool-versions` in any project
- **Direnv integration** - Works seamlessly with direnv layouts
- **Multiple languages** - Supports Node.js, Python, Go, Ruby, and more

## Usage

### Check Installed Versions

```bash
# List all installed tools
mise list

# List available Python versions
mise ls-remote python

# Show current active versions
mise current
```

### Install Additional Languages

```bash
# Install Node.js LTS
mise use -g node@lts

# Install specific Python version
mise use -g python@3.11

# Install Go latest
mise use -g go@latest
```

### Per-Project Configuration

Create `.mise.toml` in your project:

```toml
[tools]
python = "3.11"
node = "20"
```

Or use the CLI:

```bash
cd your-project
mise use python@3.11 node@20
```

### With Direnv

Use the provided direnv layouts in `.config/direnv/direnvrc`:

**Python projects:**
```bash
# .envrc
layout_python 3.12
```

**Node.js projects:**
```bash
# .envrc
layout_nodejs lts
```

**Go projects:**
```bash
# .envrc
layout_go latest
```

## Configuration Location

- **Global config:** `~/.config/mise/config.toml` (this package)
- **Per-project config:** `.mise.toml` or `.tool-versions` in project root
- **Cache:** `~/.cache/mise/`
- **Installed tools:** `~/.local/share/mise/installs/`

## Environment Variables

The global configuration sets these Python environment variables:

- `PYTHONDONTWRITEBYTECODE=1` - Prevents .pyc file generation
- `PYTHONUNBUFFERED=1` - Unbuffered output for better logging

## Updating Mise

```bash
# Update mise itself
mise self-update

# Update all installed tools to latest versions
mise upgrade

# Update specific tool
mise upgrade python
```

## Integration with Package Managers

### Python (pip)

Python packages are installed per-project using virtual environments:

```bash
# Create venv
python -m venv .venv

# Activate venv
source .venv/bin/activate

# Or use direnv layout_python which handles this automatically
```

### Node.js (npm/pnpm/yarn)

Node.js package managers are managed by Corepack (enabled automatically in shell config):

```bash
# pnpm available immediately (no global install needed)
pnpm install

# Or use direnv layout_nodejs for project-specific Node versions
```

## Troubleshooting

### Python not found after installation

```bash
# Ensure shell is properly configured
mise doctor

# Reinstall Python
mise install python@3.12

# Check PATH
mise which python
```

### Mise not activated

```bash
# Check if mise is in PATH
which mise

# Reload shell
exec zsh

# Or manually activate
eval "$(mise activate zsh)"
```

### Slow shell startup

Mise activation is fast, but if you experience slowness:

```bash
# Check mise status
mise doctor

# Disable unused plugins
# Edit ~/.config/mise/config.toml and comment out unused tools
```

## Alternative: Project-Only Approach

If you prefer not to install tools globally, comment out the `[tools]` section in the global config and only use per-project configurations.

## Cross-Platform Notes

- **macOS:** Works out of the box with Homebrew mise
- **Linux/WSL:** Ensure build dependencies are installed (gcc, make)
- **Python versions:** Requires system dependencies for building Python from source

### Linux Dependencies

For Python installation on Linux:

```bash
# Ubuntu/Debian
sudo apt-get install build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl \
  libncursesw5-dev xz-utils tk-dev libxml2-dev \
  libxmlsec1-dev libffi-dev liblzma-dev

# Fedora/RHEL
sudo dnf install gcc zlib-devel bzip2 bzip2-devel \
  readline-devel sqlite sqlite-devel openssl-devel \
  tk-devel libffi-devel xz-devel
```

Homebrew on Linux includes most of these, but system builds may need additional packages.

## See Also

- [Direnv configuration](../direnv/README.md) - Per-directory environments
- [Shell configuration](../shell/README.md) - Mise activation in shell
- [Corepack integration](../shell/README.md#nodejs--corepack) - Node.js package managers
