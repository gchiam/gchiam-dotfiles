# Setup Guide

This guide covers installation and setup procedures for the dotfiles repository.

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

## Additional Setup

### Tmux Theme Auto-Switching

Enable automatic tmux theme switching based on system appearance:

```bash
# Install fswatch for efficient monitoring (recommended)
brew install fswatch

# Setup the theme watcher service
./bin/setup-tmux-theme-watcher
```

This will automatically switch between Catppuccin Latte (light) and Frappe
(dark) themes when you change your system appearance.

## Important Paths

- Configurations: `~/.config/` (most modern tools)
- Legacy configs: `~/.*` (traditional dotfiles)
- Scripts: `~/bin/` (personal utilities)
- Package definitions: `~/.Brewfile*` (Homebrew packages)
- Documentation: `docs/` (reference guides and keybindings)
- Logs: `~/.local/log/` (service logs and debugging)
