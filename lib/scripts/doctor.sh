#!/usr/bin/env bash

set -euo pipefail

echo "🔍 Running dotfiles health check..."
echo ""
echo "Platform: linux ✓"
echo ""

echo "Required tools:"
command -v git >/dev/null 2>&1 && echo "  git: ✓" || echo "  git: ✗ not found"
command -v stow >/dev/null 2>&1 && echo "  stow: ✓" || echo "  stow: ✗ not found"
command -v brew >/dev/null 2>&1 && echo "  brew: ✓" || echo "  brew: ✗ not found"
command -v zsh >/dev/null 2>&1 && echo "  zsh: ✓" || echo "  zsh: ✗ not found"
command -v starship >/dev/null 2>&1 && echo "  starship: ✓" || echo "  starship: ✗ not found"
command -v nvim >/dev/null 2>&1 && echo "  nvim: ✓" || echo "  nvim: ✗ not found"

echo ""
echo "Optional tools:"
command -v just >/dev/null 2>&1 && echo "  just: ✓" || echo "  just: ✗"
command -v sops >/dev/null 2>&1 && echo "  sops: ✓" || echo "  sops: ✗"
command -v age >/dev/null 2>&1 && echo "  age: ✓" || echo "  age: ✗"
command -v fzf >/dev/null 2>&1 && echo "  fzf: ✓" || echo "  fzf: ✗"
command -v rg >/dev/null 2>&1 && echo "  ripgrep: ✓" || echo "  ripgrep: ✗"
command -v bat >/dev/null 2>&1 && echo "  bat: ✓" || echo "  bat: ✗"
command -v eza >/dev/null 2>&1 && echo "  eza: ✓" || echo "  eza: ✗"
command -v fd >/dev/null 2>&1 && echo "  fd: ✓" || echo "  fd: ✗"
command -v btop >/dev/null 2>&1 && echo "  btop: ✓" || echo "  btop: ✗"
command -v tmux >/dev/null 2>&1 && echo "  tmux: ✓" || echo "  tmux: ✗"

echo ""
echo "Development tools:"
command -v mise >/dev/null 2>&1 && echo "  mise: ✓" || echo "  mise: ✗"
command -v python >/dev/null 2>&1 && echo "  python: ✓ ($(python --version 2>&1 | cut -d' ' -f2))" || echo "  python: ✗"
command -v node >/dev/null 2>&1 && echo "  node: ✓" || echo "  node: ✗"
command -v corepack >/dev/null 2>&1 && echo "  corepack: ✓" || echo "  corepack: ✗"
command -v pnpm >/dev/null 2>&1 && echo "  pnpm: ✓" || echo "  pnpm: ✗"