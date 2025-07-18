# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing macOS development
environment configurations using GNU Stow for symlink management. The
repository follows a modular architecture where each tool/application has its
own configuration directory under `stow/`.

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
- **`docs/`** - Comprehensive documentation and reference guides
- **`external/`** - External dependencies (Catppuccin themes, tmux plugins)
- **`raycast/`** - Custom Raycast extensions
- **`terminfo/`** - Terminal compatibility files

### Configuration Management

Uses GNU Stow for symlink management. Each application configuration lives
in its own `stow/` subdirectory and gets symlinked to the appropriate
location in `$HOME` during setup.

### Key Configuration Categories

- **Development**: `nvim/`, `tmux/`, `git/`, `gh-dash/`
- **Shell/Terminal**: `zsh/`, `alacritty/`, `kitty/`, `wezterm/`, `starship/`
- **macOS Tools**: `aerospace/`, `karabiner/`, `raycast/`
- **Package Management**: `brew/` with main and work-specific Brewfiles
- **Scripts**: `custom-bin/` with enhanced utilities for Docker, colors, macOS

### Enhanced Script Management

The `stow/custom-bin/bin/` directory contains improved utilities:

- **Docker cleanup scripts** with error handling and confirmation prompts
- **Color palette display** with customizable columns
- **macOS dark mode detection** with cross-platform checks
- All scripts include `--help` flags and robust error handling

### Theme System

Consistent Catppuccin theming across all applications via
`external/catppuccin/` configurations.

## macOS-Specific Components

### Window Management

- **AeroSpace** (`stow/aerospace/`) - Tiling window manager
- **Yabai/SKHD** - Alternative window management (legacy)

### System Customization

- **Karabiner-Elements** - Keyboard customization
- **Raycast** - Application launcher with custom TypeScript extensions

## Development Notes

### Zsh Configuration Architecture

The zsh configuration has been completely modernized with a modular system:

- **Main config**: `.zshrc` loads all modules with safe sourcing
- **Environment detection**: Work/personal/remote/container environments
- **Performance optimization**: Lazy loading for NVM, SDKMAN, and heavy tools
- **Modular files**: `aliases.zsh`, `functions.zsh`, `completion.zsh`, etc.
- **XDG compliance**: All configs moved to `~/.config/zsh/`

### File Modifications

When modifying configurations:

1. Edit files in their respective `stow/` directories
2. Changes are immediately reflected via symlinks
3. For new configurations, add a new directory under `stow/`
4. Run linting tools before committing (see Quality Assurance section)

### Package Dependencies

- Main packages in `.Brewfile`
- Work-specific packages in `.Brewfile.zendesk`
- Version managers (asdf, nvm, jenv) handle language runtimes

### Custom Extensions

Raycast extensions in `raycast/` are TypeScript-based Node.js projects with
their own package.json files.

## Important Paths

- Configurations: `~/.config/` (most modern tools)
- Legacy configs: `~/.*` (traditional dotfiles)
- Scripts: `~/bin/` (personal utilities)
- Package definitions: `~/.Brewfile*` (Homebrew packages)
- Documentation: `docs/` (reference guides and keybindings)

## Quality Assurance

### Linting and Code Quality

Before committing changes, run appropriate linting tools:

#### Markdown Files

```bash
markdownlint-cli2 docs/*.md README.md CLAUDE.md
```

#### Shell Scripts

```bash
shellcheck bin/*.sh stow/custom-bin/bin/*
```

#### TOML Configuration

```bash
# For aerospace.toml and other TOML files
taplo fmt --check stow/aerospace/.config/aerospace/aerospace.toml
```

#### General File Checks

```bash
# Check for common issues
find . -name "*.sh" -exec shellcheck {} \;
find . -name "*.md" -exec markdownlint-cli2 {} \;
```

### Documentation Standards

- All documentation follows markdownlint rules (80 char line length,
  proper formatting)
- Scripts include `--help` flags with usage information
- Complex configurations have accompanying reference documents in `docs/`
- Use clear, descriptive commit messages following Conventional Emoji Commits

## Git Commit Guidelines

This repository follows the
[Conventional Emoji Commits](https://conventional-emoji-commits.site/)
convention for commit messages.

### Commit Format

```text
<emoji> <type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Common Types and Emojis

- `✨ feat(<scope>):` - New features
- `🐛 fix(<scope>):` - Bug fixes
- `📝 docs(<scope>):` - Documentation changes
- `💄 style(<scope>):` - Code style changes (formatting, etc.)
- `♻️ refactor(<scope>):` - Code refactoring
- `⚡ perf(<scope>):` - Performance improvements
- `✅ test(<scope>):` - Adding or updating tests
- `🔧 chore(<scope>):` - Maintenance tasks
- `🚀 ci(<scope>):` - CI/CD changes
- `🔥 remove(<scope>):` - Removing code or files
- `🎨 improve(<scope>):` - General improvements
- `🔒 security(<scope>):` - Security fixes

### Common Scopes

- `zsh` - Zsh shell configuration
- `nvim` - Neovim editor configuration
- `tmux` - Tmux terminal multiplexer
- `git` - Git configuration
- `brew` - Homebrew package management
- `aerospace` - AeroSpace window manager
- `karabiner` - Karabiner keyboard customization
- `raycast` - Raycast launcher and extensions
- `alacritty` - Alacritty terminal
- `bin` - Utility scripts
- `docs` - Documentation files

### Examples

```bash
✨ feat(zsh): add modular configuration system with custom functions
🐛 fix(ssh): resolve SSH config overwrite vulnerability
📝 docs(readme): update README with comprehensive setup guide  
♻️ refactor(nvim): reorganize plugin configuration structure
🔧 chore(brew): update package dependencies to latest versions
🔒 security(ssh): fix SSH agent management to prevent multiple agents
⚡ perf(zsh): implement lazy loading for NVM and development tools
🎨 improve(bin): enhance scripts with better error handling
```
