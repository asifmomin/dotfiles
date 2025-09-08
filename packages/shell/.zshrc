# Zsh configuration entry point
# This file sources the actual configuration from XDG-compliant location

# Set XDG directories if not already set
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Source the main zsh configuration
if [[ -f "$XDG_CONFIG_HOME/zsh/.zshrc" ]]; then
    source "$XDG_CONFIG_HOME/zsh/.zshrc"
else
    echo "Warning: Zsh configuration not found at $XDG_CONFIG_HOME/zsh/.zshrc"
    echo "Run 'just stow-apply' to install dotfiles configuration"
fi