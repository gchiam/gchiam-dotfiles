# Specification: Unified Theme Orchestrator

## Overview

Centralize and automate system-wide theme switching (Dark/Light mode) across all
applications in the dotfiles environment. This orchestrator will ensure visual
consistency by synchronizing the Catppuccin theme flavor across Neovim, Tmux,
terminals, and CLI tools when the macOS system theme changes.

## Problem Statement

Currently, theme switching is fragmented:

- Tmux has two separate watchers (`fswatch` and polling).
- Neovim uses a dedicated plugin.
- Terminals and other tools often require manual restarts or independent
  monitoring.
- This fragmentation causes delays, inconsistent states, and redundant resource
  usage.

## Goals

- **Centralization**: A single script (`bin/theme-sync.sh`) to monitor system
  theme changes.
- **Efficiency**: Use `fswatch` to avoid polling.
- **Consistency**: Immediate synchronization across all supported tools.
- **Maintainability**: Unified logic for determining the correct Catppuccin
  flavor (Frappe for Dark, Latte for Light).

## Technical Approach

1. **Monitor**: Use `fswatch` on
   `~/Library/Preferences/.GlobalPreferences.plist`.
2. **Detect**: Read `AppleInterfaceStyle` using `defaults`.
3. **Broadcast**:
   - **Tmux**: `tmux source-file ~/.tmux.conf`.
   - **Neovim**: Write the current theme to a state file or send a signal.
   - **Terminals**: `alacritty` and `wezterm` usually reload on file change;
     ensure the imported theme file is updated.
   - **Shell**: Update environment variables or aliases.

## Success Criteria

- Switching macOS Appearance from Light to Dark automatically updates all active
  terminal panes and editors to Catppuccin Frappe.
- Switching back to Light updates everything to Catppuccin Latte.
- Minimal CPU overhead during idle monitoring.
