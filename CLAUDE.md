# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing macOS development environment configurations using GNU Stow for symlink management. The repository follows a modular architecture where each tool/application has its own configuration directory under `stow/`.

## Common Commands

### Setup and Installation
```bash
./bin/setup.sh                      # Main installation script using Stow
./bin/setup-git.sh                  # Configure Git settings
./bin/add-github-to-ssh-config.sh   # Setup SSH for GitHub
```

### Package Management
```bash
# Install all packages from main Brewfile
brew bundle --file=~/.Brewfile

# Update package lists
./bin/update-brew.sh

# Manual Stow operations
stow -d stow -t ~ <directory>       # Link specific config
stow -d stow -t ~ -D <directory>    # Unlink specific config
```

### Development Environment
```bash
# Neovim (LazyVim) - primary editor
nvim

# Terminal multiplexing
tmux

# Shell environment uses zsh with antidote plugin manager
# Version managers: asdf, nvm, jenv are configured
```

## Architecture

### Core Structure
- **`stow/`** - Main configuration directory with 29+ tool configurations
- **`bin/`** - Setup scripts and utilities
- **`external/`** - External dependencies (Catppuccin themes, tmux plugins)
- **`raycast/`** - Custom Raycast extensions
- **`terminfo/`** - Terminal compatibility files

### Configuration Management
Uses GNU Stow for symlink management. Each application configuration lives in its own `stow/` subdirectory and gets symlinked to the appropriate location in `$HOME` during setup.

### Key Configuration Categories
- **Development**: `nvim/`, `tmux/`, `git/`, `gh-dash/`
- **Shell/Terminal**: `zsh/`, `alacritty/`, `kitty/`, `wezterm/`, `starship/`
- **macOS Tools**: `aerospace/`, `karabiner/`, `raycast/`
- **Package Management**: `brew/` with main and work-specific Brewfiles

### Theme System
Consistent Catppuccin theming across all applications via `external/catppuccin/` configurations.

## macOS-Specific Components

### Window Management
- **AeroSpace** (`stow/aerospace/`) - Tiling window manager
- **Yabai/SKHD** - Alternative window management (legacy)

### System Customization
- **Karabiner-Elements** - Keyboard customization
- **Raycast** - Application launcher with custom TypeScript extensions

## Development Notes

### File Modifications
When modifying configurations:
1. Edit files in their respective `stow/` directories
2. Changes are immediately reflected via symlinks
3. For new configurations, add a new directory under `stow/`

### Package Management
- Main packages in `.Brewfile`
- Work-specific packages in `.Brewfile.zendesk` 
- Version managers (asdf, nvm, jenv) handle language runtimes

### Custom Extensions
Raycast extensions in `raycast/` are TypeScript-based Node.js projects with their own package.json files.

## Important Paths
- Configurations: `~/.config/` (most modern tools)
- Legacy configs: `~/.*` (traditional dotfiles)
- Scripts: `~/bin/` (personal utilities)
- Package definitions: `~/.Brewfile*` (Homebrew packages)
