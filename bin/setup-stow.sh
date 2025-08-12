#!/bin/bash
set -euo pipefail

# Stow setup script for dotfiles
# Stows all configuration directories using GNU Stow

# Configuration
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Stow all configuration directories
stow_dir="$DOTFILES_DIR/stow"
if [[ ! -d "$stow_dir" ]]; then
    echo "Error: Stow directory $stow_dir does not exist" >&2
    exit 1
fi

echo "Stowing configurations from $stow_dir..."
cd "$stow_dir"

for d in *; do
    [[ -d "$d" ]] || continue
    echo "Stowing $d..."
    if stow -v --dir="$stow_dir" --target="$HOME" --restow "$d"; then
        echo "✓ Successfully stowed $d"
    else
        echo "✗ Failed to stow $d" >&2
        # Continue with other directories instead of failing completely
    fi
done

cd - > /dev/null