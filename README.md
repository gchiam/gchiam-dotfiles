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

## Documentation

For detailed guidance and references:

### Getting Started

- **[Setup Guide](docs/setup-guide.md)** - Installation procedures and
  initial configuration
- **[Architecture](docs/architecture.md)** - Repository structure and
  component overview

### Development Workflow

- **[Development Notes](docs/development-notes.md)** - Development practices
  and workflow
- **[Quality Assurance](docs/quality-assurance.md)** - Linting standards
  and code quality
- **[Commit Guidelines](docs/commit-guidelines.md)** - Git commit conventions
  and best practices

### Tool References

- **[Zsh Reference](docs/zsh-reference.md)** - Comprehensive zsh configuration,
  aliases, functions, and keybindings guide
- **[WezTerm Reference](docs/wezterm-reference.md)** - Complete WezTerm terminal
  emulator configuration and usage guide
- **[Tmux Reference](docs/tmux-reference.md)** - Complete tmux keybindings
  and configuration guide
- **[Neovim Reference](docs/neovim-reference.md)** - LazyVim configuration
  and keybindings guide
- **[AeroSpace Reference](docs/aerospace-reference.md)** - Window manager
  keybindings and workspace setup
- **[Git Aliases Reference](docs/git-aliases-reference.md)** - Comprehensive
  guide to all git aliases and commands

### Meta

- **[CLAUDE.md](./CLAUDE.md)** - Main guidance document for Claude Code
