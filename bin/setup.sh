#!/bin/bash
set -euo pipefail

# Main dotfiles setup script using GNU Stow
# Creates symlinks for all configuration directories

# Source utility functions
# shellcheck source=bin/lib/utils.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib/utils.sh"

# Configuration
DOTFILES_SOURCE="${DOTFILES_SOURCE:-$HOME/projects/gchiam-dotfiles}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

print_header "Setting up dotfiles..."

# Argument parsing
DEBUG_MODE=false
while [[ "$#" -gt 0 ]]; do
  key="$1"
  case $key in
    --debug)
      DEBUG_MODE=true
      shift # past argument
      ;;
    --help|-h)
      echo "Usage: setup.sh [--debug]"
      exit 0
      ;;
    *)
      echo "Error: Unknown argument: $key" >&2
      exit 1
      ;;
  esac
done

# Verify source directory exists
verify_dotfiles_dir "$DOTFILES_SOURCE" || exit 1

if [[ "$DEBUG_MODE" == true ]]; then
    print_info "Debug mode is enabled."
fi

# Create symlink to dotfiles directory
print_step "Creating symlink: $DOTFILES_DIR → $DOTFILES_SOURCE"
if [[ -L "$DOTFILES_DIR" ]] || [[ ! -e "$DOTFILES_DIR" ]]; then
    ln -snvf "$DOTFILES_SOURCE" "$DOTFILES_DIR"
else
    print_warning "$DOTFILES_DIR exists and is not a symlink. Skipping."
fi

# Verify and install stow if needed
if ! command -v stow &> /dev/null; then
    print_info "stow not found. Installing via Homebrew..."
    ensure_homebrew || exit 1
    brew install stow
fi

# Verify and install gitleaks if needed
if ! command -v gitleaks &> /dev/null; then
    print_info "gitleaks not found. Installing via Homebrew..."
    ensure_homebrew || exit 1
    brew install gitleaks
fi

# Stow all configuration directories
"$DOTFILES_SOURCE/bin/setup-stow.sh" --non-interactive "$@"

# Rebuild bat cache for themes (if bat is available)
if command -v bat &> /dev/null; then
    print_step "Rebuilding bat cache..."
    bat cache --build
else
    print_info "bat not found, skipping cache rebuild"
fi

# Configure ZSH Fast Syntax Highlighting theme (if available)
if command -v fast-theme &> /dev/null; then
    print_step "Setting fast-syntax-highlighting theme..."
    fast-theme XDG:catppuccin-frappe
else
    print_info "fast-theme not found, skipping theme configuration"
fi

# Generate Fleet properties file
print_step "Generating Fleet configuration..."
echo "fleet.config.path=${HOME}/.config/JetBrains/Fleet/" > ~/fleet.properties

# Setup fzf directory structure
print_step "Setting up fzf directory..."
ensure_dir "$HOME/.fzf/fzf.zsh"
if [[ -f "$HOME/.fzf.zsh" ]]; then
    ln -snvf "$HOME/.fzf.zsh" "$HOME/.fzf/fzf.zsh"
fi

print_success "Dotfiles setup completed successfully!"