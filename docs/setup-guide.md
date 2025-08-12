# Setup Guide

This comprehensive guide covers installation and setup procedures for the
dotfiles repository, from initial setup to advanced configuration.

## Navigation

**📖 Documentation:** [← Back to Main README](../README.md) |
**🏗️ Architecture:** [Repository Structure →](architecture.md)

**🔄 Next Steps:** After setup, see [Workflow Guide](workflow-guide.md) for
daily usage patterns

**🆘 Having Issues?** Check the [Troubleshooting Guide](troubleshooting.md)
for common problems

---

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

## Post-Installation

### Verification Steps

After installation, verify everything is working:

```bash
# Run comprehensive health check
./bin/health-check.sh all

# Check shell completion system
./bin/setup-completions.sh test

# Verify package installations
brew bundle check --file=~/.Brewfile

# Test key applications
nvim +checkhealth +quit       # Neovim health check
tmux info                      # tmux configuration
git --version                  # Git with delta integration
```

### Shell Completion Setup

```bash
# Install tab completion for all dotfiles scripts
./bin/setup-completions.sh install

# Test completions (restart shell first)
exec zsh
./bin/auto-sync.sh <TAB>       # Should show available commands
```

### First-Time Configuration

```bash
# Configure Git (if not already done)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Setup SSH for GitHub (if needed)
./bin/add-github-to-ssh-config.sh

# Install git hooks for validation
./bin/setup-git-hooks.sh install
```

## Directory Structure and Important Paths

### Configuration Locations

```text
~/.config/                    # Modern XDG-compliant configurations
├── zsh/                     # Zsh shell configuration
├── nvim/                    # Neovim editor configuration
├── tmux/                    # tmux terminal multiplexer
├── alacritty/               # Alacritty terminal emulator
├── aerospace/               # AeroSpace window manager
└── karabiner/               # Karabiner-Elements keyboard customization

~/.*                         # Legacy dotfiles (when required)
├── .zshrc                   # Main zsh configuration file
├── .tmux.conf               # tmux configuration file
├── .gitconfig               # Git configuration
└── .Brewfile*               # Homebrew package definitions

~/bin/                       # Personal utility scripts
├── setup*.sh                # Installation and setup scripts
├── health*.sh               # Health monitoring scripts
├── performance*.sh          # Performance monitoring tools
└── auto*.sh                 # Automation scripts
```

### Repository Structure

```text
~/.dotfiles/
├── bin/                     # Setup and utility scripts
├── docs/                    # Comprehensive documentation
├── stow/                    # Stow package directories
│   ├── nvim/               # Neovim configuration
│   ├── zsh/                # Zsh configuration
│   ├── tmux/               # tmux configuration
│   └── ...                 # Other tool configurations
├── external/               # External dependencies and themes
├── raycast/                # Custom Raycast extensions
└── terminfo/               # Terminal compatibility files
```

### Log and Cache Locations

```text
~/.local/log/               # Service logs and debugging
~/.cache/                   # Application caches
~/.local/share/             # Application data
~/.local/state/             # Application state files
```

## Troubleshooting

If you encounter issues during setup:

1. **Check the [Troubleshooting Guide](troubleshooting.md)** for common issues
   and solutions
2. **Run health check**: `./bin/health-check.sh all`
3. **Check compatibility**: `./bin/check-compatibility.sh --report`
4. **View logs**: Check `~/.local/log/` for detailed error information
5. **Reset if needed**: Use `./bin/setup-interactive.sh --backup` to create
   backups before trying fixes

## Next Steps

After successful installation:

1. **Read tool-specific documentation** in the `docs/` directory
2. **Customize configurations** by editing files in `stow/` directories
3. **Set up automation** with health monitoring and auto-sync
4. **Learn keybindings** from the reference guides
5. **Join the workflow** by following the development notes
