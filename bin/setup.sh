#!/bin/bash
set -euo pipefail

# Main dotfiles setup script using GNU Stow
# Creates symlinks for all configuration directories

# Configuration
DOTFILES_SOURCE="${DOTFILES_SOURCE:-$HOME/projects/gchiam-dotfiles}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

echo "Setting up dotfiles..."

# Verify source directory exists
if [[ ! -d "$DOTFILES_SOURCE" ]]; then
    echo "Error: Source directory $DOTFILES_SOURCE does not exist" >&2
    exit 1
fi

# Create symlink to dotfiles directory
echo "Creating symlink: $DOTFILES_DIR → $DOTFILES_SOURCE"
if [[ -L "$DOTFILES_DIR" ]] || [[ ! -e "$DOTFILES_DIR" ]]; then
    ln -snvf "$DOTFILES_SOURCE" "$DOTFILES_DIR"
else
    echo "Warning: $DOTFILES_DIR exists and is not a symlink. Skipping." >&2
fi

# Verify and install stow if needed
if ! command -v stow &> /dev/null; then
    echo "stow not found. Installing via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install stow
    else
        echo "Error: Neither stow nor brew is available. Please install stow manually." >&2
        exit 1
    fi
fi

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

# Rebuild bat cache for themes (if bat is available)
if command -v bat &> /dev/null; then
    echo "Rebuilding bat cache..."
    bat cache --build
else
    echo "bat not found, skipping cache rebuild"
fi

# Configure ZSH Fast Syntax Highlighting theme (if available)
if command -v fast-theme &> /dev/null; then
    echo "Setting fast-syntax-highlighting theme..."
    fast-theme XDG:catppuccin-frappe
else
    echo "fast-theme not found, skipping theme configuration"
fi

# Generate Fleet properties file
echo "Generating Fleet configuration..."
echo "fleet.config.path=${HOME}/.config/JetBrains/Fleet/" > ~/fleet.properties

# Setup fzf directory structure
echo "Setting up fzf directory..."
mkdir -p "$HOME/.fzf"
if [[ -f "$HOME/.fzf.zsh" ]]; then
    ln -snvf "$HOME/.fzf.zsh" "$HOME/.fzf/fzf.zsh"
fi

echo "✓ Dotfiles setup completed successfully!"