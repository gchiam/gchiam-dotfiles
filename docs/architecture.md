# Architecture Overview

This document describes the overall architecture and structure of the dotfiles
repository.

## Core Structure

- **`stow/`** - Main configuration directory with 29+ tool configurations
- **`bin/`** - Setup scripts and utilities
- **`docs/`** - Comprehensive documentation and reference guides
- **`external/`** - External dependencies (Catppuccin themes, tmux plugins)
- **`raycast/`** - Custom Raycast extensions
- **`terminfo/`** - Terminal compatibility files

## Configuration Management

Uses GNU Stow for symlink management. Each application configuration lives
in its own `stow/` subdirectory and gets symlinked to the appropriate
location in `$HOME` during setup.

## Key Configuration Categories

- **Development**: `nvim/`, `tmux/`, `git/`, `gh-dash/`
- **Shell/Terminal**: `zsh/`, `alacritty/`, `kitty/`, `wezterm/`, `starship/`
- **macOS Tools**: `aerospace/`, `karabiner/`, `raycast/`
- **Package Management**: `brew/` with main and work-specific Brewfiles
- **Scripts**: `custom-bin/` with enhanced utilities for Docker, colors, macOS

## Enhanced Script Management

The `stow/custom-bin/bin/` directory contains improved utilities:

- **Docker cleanup scripts** with error handling and confirmation prompts
- **Color palette display** with customizable columns
- **macOS dark mode detection** with cross-platform checks
- All scripts include `--help` flags and robust error handling

## Theme System

Consistent Catppuccin theming across all applications via
`external/catppuccin/` configurations.

## macOS-Specific Components

### Window Management

- **AeroSpace** (`stow/aerospace/`) - Tiling window manager
- **Yabai/SKHD** - Alternative window management (legacy)

### System Customization

- **Karabiner-Elements** - Keyboard customization
- **Raycast** - Application launcher with custom TypeScript extensions

## Package Dependencies

- Main packages in `.Brewfile`
- Work-specific packages in `.Brewfile.zendesk`
- Version managers (asdf, nvm, jenv) handle language runtimes

## Custom Extensions

Raycast extensions in `raycast/` are TypeScript-based Node.js projects with
their own package.json files.
