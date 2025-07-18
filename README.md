# My dotfiles

Personal macOS development environment configuration files managed with GNU Stow.

## Quick Setup

```bash
# Clone the repository
git clone https://github.com/gchiam/gchiam-dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the main setup script
./bin/setup.sh
```

## What's Included

- **Shell**: Zsh with antidote plugin manager
- **Editor**: Neovim (LazyVim distribution)
- **Terminal**: Alacritty, Kitty, WezTerm configurations
- **Window Management**: AeroSpace tiling window manager
- **Package Management**: Homebrew with curated package lists
- **Git**: Enhanced with delta for better diffs
- **Theming**: Consistent Catppuccin color scheme across all tools

## Key Features

- **Modular Architecture**: Each tool has its own configuration directory
- **Stow-based Management**: Clean symlink organization
- **macOS Optimized**: Tailored for Apple Silicon Macs
- **Work Integration**: Separate configurations for professional tools

## Manual Installation

For selective installation of specific configurations:

```bash
# Install specific tool configurations
stow -d stow -t ~ nvim    # Neovim config
stow -d stow -t ~ zsh     # Zsh config
stow -d stow -t ~ git     # Git config
```

## Package Management

```bash
# Install all packages
brew bundle --file=~/.Brewfile

# Update packages
./bin/update-brew.sh
```

For detailed guidance, see [CLAUDE.md](./CLAUDE.md).
