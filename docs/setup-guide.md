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

## Important Paths

- Configurations: `~/.config/` (most modern tools)
- Legacy configs: `~/.*` (traditional dotfiles)
- Scripts: `~/bin/` (personal utilities)
- Package definitions: `~/.Brewfile*` (Homebrew packages)
- Documentation: `docs/` (reference guides and keybindings)
