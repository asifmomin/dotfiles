# Dotfiles management with just
# Usage: just <command>

set shell := ["bash", "-euo", "pipefail", "-c"]

# Default recipe to display help
default:
	@just --list

# Full bootstrap: install packages, apply configs, setup shell
bootstrap: install-packages stow-apply setup-shell
	@echo "🎉 Bootstrap completed! Run 'just doctor' to verify installation."
	@echo ""
	@echo "Next steps:"
	@echo "  1. Restart your terminal or run: exec zsh"
	@echo "  2. Run: just doctor"
	@echo "  3. Setup secrets: just secrets-init"

# Install all packages via Homebrew
install-packages:
	@echo "📦 Installing packages via Homebrew..."
	@if [[ -f "platform/brew/Brewfile" ]]; then \
		brew bundle --file=platform/brew/Brewfile; \
		echo "✓ Packages installed from Brewfile"; \
	else \
		echo "⚠ Brewfile not found, installing essential tools only"; \
		brew install stow git zsh starship neovim tmux; \
	fi
	@if command -v mise >/dev/null 2>&1; then \
		echo "🐍 Installing mise runtimes (Python, Node.js, etc.)..."; \
		mise install; \
		echo "✓ Mise runtimes installed"; \
	fi

# Health check all tools and configurations
doctor:
	@lib/scripts/doctor.sh

# Dry run stow operations (show what would be linked)
stow-check:
	@lib/scripts/stow-check.sh

# Apply all stow packages
stow-apply:
	@lib/scripts/stow-apply.sh

# Remove all stow packages
stow-remove:
	@lib/scripts/stow-remove.sh

# Restow all packages (remove then apply)
stow-restow:
	just stow-remove
	just stow-apply

# Setup shell (register zsh and set as default)
setup-shell:
	@lib/scripts/setup-shell.sh

# Initialize secrets management (generate age keys)
[group('secrets')]
secrets-init:
	@lib/scripts/secrets.sh init

# Edit encrypted file with sops
[group('secrets')]
secrets-edit f:
	@lib/scripts/secrets.sh edit "{{f}}"

# Apply/decrypt secrets to their destinations
[group('secrets')]
secrets-apply:
	@lib/scripts/secrets-apply.sh

# Show decrypted content of a secret file
[group('secrets')]
secrets-show f:
	@lib/scripts/secrets.sh show "{{f}}"

# Clone (if needed) and wire up portable Claude Code memory pointers
claude-memory-link:
	@echo "🧠 Linking Claude Code memory..."
	@if [[ ! -d ~/workspace/claude-memory ]]; then \
		echo "Cloning claude-memory repo..."; \
		git clone git@github.com:asifmomin/claude-memory.git ~/workspace/claude-memory; \
	fi
	@~/workspace/claude-memory/bootstrap-pointers.sh

# Update everything (packages, dotfiles, secrets)
update:
	@echo "🔄 Updating everything..."
	git pull origin main
	just install-packages
	just stow-restow
	@echo "✓ Update completed!"

# Clean up broken symlinks and backup files
clean:
	@echo "🧹 Cleaning up..."
	@find ~ -maxdepth 1 -type l ! -exec test -e {} \; -delete 2>/dev/null || true
	@find ~ -maxdepth 1 -name "*.backup" -delete 2>/dev/null || true
	@find ~/.config -name "*.backup" -delete 2>/dev/null || true
	@echo "✓ Cleanup completed"

# Show dotfiles status and info
status:
	@echo "📊 Dotfiles Status"
	@echo "=================="
	@echo ""
	@git remote get-url origin | sed 's/^/Repository: /'
	@git branch --show-current | sed 's/^/Branch: /'
	@git log -1 --format='Last commit: %h %s (%cr)'
	@echo ""
	@echo "Installed packages:"
	@ls packages/
	@echo ""

# Open dotfiles directory
edit:
	@echo "📝 Opening dotfiles directory..."
	@"$${EDITOR:-nvim}" .

# Show this help
help:
	@echo "Dotfiles Management Commands"
	@echo "==========================="
	@echo ""
	@echo "Setup & Installation:"
	@echo "  bootstrap        Full setup (packages + stow + secrets)"
	@echo "  install-packages Install all packages via Homebrew"
	@echo "  doctor          Health check all tools"
	@echo ""
	@echo "Stow Management:"
	@echo "  stow-check      Dry run stow operations"
	@echo "  stow-apply      Apply all packages"
	@echo "  stow-remove     Remove all packages"
	@echo "  stow-restow     Remove then reapply packages"
	@echo ""
	@echo "Secrets Management:"
	@echo "  secrets-init    Generate age keys"
	@echo "  secrets-edit f= Edit encrypted file"
	@echo "  secrets-show f= Show decrypted content"
	@echo "  secrets-apply   Apply decrypted secrets"
	@echo ""
	@echo "Maintenance:"
	@echo "  update          Update packages and dotfiles"
	@echo "  clean           Remove broken symlinks"
	@echo "  status          Show dotfiles info"
	@echo "  edit            Open dotfiles in editor"