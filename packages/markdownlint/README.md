# Markdownlint Configuration

Configuration for markdownlint linting in Neovim and other markdown tools.

## Overview

This package provides global markdownlint configuration files:
- `.markdownlint-cli2.jsonc` - For markdownlint-cli2 (used by Neovim's nvim-lint)
- `.markdownlintrc` - For legacy markdownlint and VS Code extension

## Configuration Details

Both configuration files disable or adjust overly strict rules:

- **MD022** (blanks-around-headings): Disabled - too strict for informal documentation
- **MD032** (blanks-around-lists): Disabled - too strict for informal documentation
- **MD013** (line-length): Set to 120 chars, excludes code blocks and tables

All other markdownlint rules remain enabled with their defaults.

## Customization

To modify rules, edit the config files in `packages/markdownlint/` and run:

```bash
just stow-restow
```

See [markdownlint rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md) for all available options.

## Platform Support

- macOS: Full support
- Linux: Full support
- WSL: Full support

Works anywhere markdownlint is installed.
