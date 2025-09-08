# Dotfiles management with just
# Usage: just <command>

set shell := ["bash", "-euo", "pipefail", "-c"]

# Default recipe to display help
default:
	@just --list

# Full bootstrap: install packages, apply configs, setup secrets
bootstrap: install-packages stow-apply
	@echo "🎉 Bootstrap completed! Run 'just doctor' to verify installation."
	@echo ""
	@echo "Next steps:"
	@echo "  1. Restart your shell: exec \$SHELL"
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

# Health check all tools and configurations
doctor:
	@echo "🔍 Running dotfiles health check..."
	@echo ""
	@echo "Platform: linux ✓"
	@echo ""
	@echo "Required tools:"
	@command -v git >/dev/null 2>&1 && echo "  git: ✓" || echo "  git: ✗ not found"
	@command -v stow >/dev/null 2>&1 && echo "  stow: ✓" || echo "  stow: ✗ not found"
	@command -v brew >/dev/null 2>&1 && echo "  brew: ✓" || echo "  brew: ✗ not found"
	@command -v zsh >/dev/null 2>&1 && echo "  zsh: ✓" || echo "  zsh: ✗ not found"
	@command -v starship >/dev/null 2>&1 && echo "  starship: ✓" || echo "  starship: ✗ not found"
	@command -v nvim >/dev/null 2>&1 && echo "  nvim: ✓" || echo "  nvim: ✗ not found"
	@echo ""
	@echo "Optional tools:"
	@command -v just >/dev/null 2>&1 && echo "  just: ✓" || echo "  just: ✗"
	@command -v sops >/dev/null 2>&1 && echo "  sops: ✓" || echo "  sops: ✗"
	@command -v age >/dev/null 2>&1 && echo "  age: ✓" || echo "  age: ✗"
	@command -v fzf >/dev/null 2>&1 && echo "  fzf: ✓" || echo "  fzf: ✗"
	@command -v rg >/dev/null 2>&1 && echo "  ripgrep: ✓" || echo "  ripgrep: ✗"
	@command -v bat >/dev/null 2>&1 && echo "  bat: ✓" || echo "  bat: ✗"
	@command -v eza >/dev/null 2>&1 && echo "  eza: ✓" || echo "  eza: ✗"
	@command -v fd >/dev/null 2>&1 && echo "  fd: ✓" || echo "  fd: ✗"
	@command -v btop >/dev/null 2>&1 && echo "  btop: ✓" || echo "  btop: ✗"
	@command -v tmux >/dev/null 2>&1 && echo "  tmux: ✓" || echo "  tmux: ✗"

# Dry run stow operations (show what would be linked)
stow-check:
	@echo "🔍 Checking stow operations (dry run)..."
	@echo ""
	@cd packages && for package in */; do \
		if [[ -d "$$package" ]]; then \
			name=$${package%/}; \
			echo "Package: $$name"; \
			stow -d . -t ~ -n -v "$$name" 2>&1 | sed 's/^/  /' || true; \
			echo ""; \
		fi; \
	done

# Apply all stow packages
stow-apply:
	@echo "🔗 Applying stow packages..."
	@cd packages && applied=0; \
	for package in */; do \
		if [[ -d "$$package" ]]; then \
			name=$${package%/}; \
			echo "Applying package: $$name"; \
			if stow -d . -t ~ "$$name"; then \
				echo "  ✓ $$name applied successfully"; \
				((applied++)); \
			else \
				echo "  ✗ $$name failed to apply"; \
			fi; \
		fi; \
	done; \
	echo ""; \
	echo "✓ Applied $$applied packages"
	@if [[ -f ~/.zshrc ]]; then \
		echo "💡 Restart your shell to load new configuration"; \
	fi

# Remove all stow packages
stow-remove:
	@echo "🗑️  Removing stow packages..."
	@cd packages && removed=0; \
	for package in */; do \
		if [[ -d "$$package" ]]; then \
			name=$${package%/}; \
			echo "Removing package: $$name"; \
			if stow -d . -t ~ -D "$$name"; then \
				echo "  ✓ $$name removed successfully"; \
				((removed++)); \
			else \
				echo "  ✗ $$name failed to remove"; \
			fi; \
		fi; \
	done; \
	echo ""; \
	echo "✓ Removed $$removed packages"

# Restow all packages (remove then apply)
stow-restow:
	just stow-remove
	just stow-apply

# Initialize secrets management (generate age keys)
[group('secrets')]
secrets-init:
	@echo "🔐 Initializing secrets management..."
	@if ! command -v age >/dev/null 2>&1; then \
		echo "❌ age is not installed. Run 'just install-packages' first."; \
		exit 1; \
	fi
	@age_key="$$HOME/.config/sops/age/keys.txt"; \
	if [[ ! -f "$$age_key" ]]; then \
		echo "Generating age key..."; \
		mkdir -p "$$(dirname "$$age_key")"; \
		age-keygen -o "$$age_key"; \
		echo "✓ Age key generated: $$age_key"; \
	else \
		echo "✓ Age key already exists: $$age_key"; \
	fi
	@age_key="$$HOME/.config/sops/age/keys.txt"; \
	echo ""; \
	echo "Your age public key (add this to .sops.yaml):"; \
	grep -o 'age1[a-zA-Z0-9]*' "$$age_key"; \
	echo ""; \
	echo "💡 Edit .sops.yaml and replace 'age1...' with your public key above"

# Edit encrypted file with sops
[group('secrets')]
secrets-edit f:
	@echo "✏️  Editing encrypted file: {{f}}"
	@if [[ ! -f "{{f}}" ]]; then \
		echo "Creating new encrypted file: {{f}}"; \
		mkdir -p "$$(dirname "{{f}}")"; \
		echo "# Encrypted secrets file" > "{{f}}"; \
	fi
	sops "{{f}}"

# Apply/decrypt secrets to their destinations
[group('secrets')]
secrets-apply:
	@echo "🔓 Applying secrets..."
	@if [[ -f "secrets/examples/ssh_config.sops.yaml" ]]; then \
		echo "💡 Found SSH config example - implement decryption logic as needed"; \
	fi
	@echo "✓ Secrets applied (implement specific logic in justfile)"

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
	@echo "  secrets-apply   Apply decrypted secrets"
	@echo ""
	@echo "Maintenance:"
	@echo "  update          Update packages and dotfiles"
	@echo "  clean           Remove broken symlinks"
	@echo "  status          Show dotfiles info"
	@echo "  edit            Open dotfiles in editor"