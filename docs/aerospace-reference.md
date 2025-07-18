# AeroSpace Reference Guide

A comprehensive guide to AeroSpace tiling window manager configuration and
keybindings for macOS.

## Overview

AeroSpace is a i3-like tiling window manager for macOS that provides automatic
window arrangement, workspace management, and keyboard-driven navigation. This
configuration provides a productivity-focused setup with vim-style navigation.

## Core Concepts

### Workspaces

AeroSpace uses both numbered (1-9) and lettered (A-Z) workspaces:

- **Numbers (1-9)**: Primary workspaces for general use
- **Letters (A-Z)**: Specialized workspaces for specific applications
- Applications can be automatically assigned to specific workspaces

### Layouts

- **Tiles**: Default layout with automatic window arrangement
- **Accordion**: Stacked layout with tab-like window management
- **Floating**: Traditional overlapping windows (for specific apps)

### Binding Modes

- **Main**: Default mode for regular operations
- **Service**: Administrative operations (reload, reset, etc.)
- **Resize**: Dedicated mode for window resizing

## Keybindings

### Focus Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + h` | Focus left | Move focus to window on the left |
| `Alt + j` | Focus down | Move focus to window below |
| `Alt + k` | Focus up | Move focus to window above |
| `Alt + l` | Focus right | Move focus to window on the right |

### Window Movement

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + h` | Move left | Move window to the left |
| `Alt + Shift + j` | Move down | Move window down |
| `Alt + Shift + k` | Move up | Move window up |
| `Alt + Shift + l` | Move right | Move window to the right |

### Window Resizing

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + -` | Resize smaller | Decrease window size by 50px |
| `Alt + Shift + =` | Resize larger | Increase window size by 50px |

### Layout Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + /` | Toggle tiles | Cycle through horizontal/vertical tiles |
| `Alt + ,` | Toggle accordion | Cycle through accordion layouts |

### Workspace Navigation

#### Numbered Workspaces (1-9)

| Keybinding | Action |
|------------|--------|
| `Alt + 1` to `Alt + 9` | Switch to workspace 1-9 |

#### Lettered Workspaces (A-Z)

| Keybinding | Action | Typical Use |
|------------|--------|-------------|
| `Alt + a` | Workspace A | General applications |
| `Alt + b` | Workspace B | Browser/web |
| `Alt + c` | Workspace C | Communication |
| `Alt + d` | Workspace D | Development |
| `Alt + e` | Workspace E | Email |
| `Alt + f` | Workspace F | Files/Finder |
| `Alt + g` | Workspace G | Graphics/design |
| `Alt + i` | Workspace I | IDE/IntelliJ |
| `Alt + m` | Workspace M | Music/media |
| `Alt + n` | Workspace N | Notes |
| `Alt + o` | Workspace O | Office/productivity |
| `Alt + p` | Workspace P | Presentations |
| `Alt + q` | Workspace Q | Logseq/knowledge |
| `Alt + r` | Workspace R | Research |
| `Alt + s` | Workspace S | Systems/monitoring |
| `Alt + t` | Workspace T | Terminal |
| `Alt + u` | Workspace U | Utilities |
| `Alt + v` | Workspace V | VS Code |
| `Alt + w` | Workspace W | Writing |
| `Alt + x` | Workspace X | Experimental |
| `Alt + y` | Workspace Y | Miscellaneous |
| `Alt + z` | Workspace Z | Archive |

### Move Window to Workspace

#### To Numbered Workspaces

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + 1` to `Alt + Shift + 9` | Move window to workspace 1-9 |

#### To Lettered Workspaces

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + a` to `Alt + Shift + z` | Move window to workspace A-Z |

### Move Window and Follow

These keybindings move the window and immediately switch to that workspace:

#### Numbered Workspaces

| Keybinding | Action |
|------------|--------|
| `Cmd + Alt + 1` to `Cmd + Alt + 9` | Move window to workspace 1-9 and follow |

#### Lettered Workspaces

| Keybinding | Action |
|------------|--------|
| `Cmd + Alt + a` to `Cmd + Alt + z` | Move window to workspace A-Z and follow |

### Workspace Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Tab` | Last workspace | Switch to previously active workspace |
| `Alt + Shift + Tab` | Move workspace | Move workspace to next monitor |

### Fullscreen

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + Shift + f` | Fullscreen on | Enable fullscreen mode |
| `Ctrl + Shift + g` | Fullscreen off | Disable fullscreen mode |

### Mode Switching

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + ;` | Service mode | Enter service/admin mode |
| `Ctrl + Shift + r` | Resize mode | Enter resize mode |

### Disabled macOS Shortcuts

| Keybinding | Original Action | Status |
|------------|------------------|--------|
| `Cmd + h` | Hide application | Disabled |
| `Cmd + Alt + h` | Hide others | Disabled |

## Service Mode

Enter service mode with `Alt + Shift + ;`:

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Esc` | Exit and reload | Reload config and return to main mode |
| `r` | Reset layout | Flatten workspace tree and return to main |
| `f` | Toggle floating | Switch between floating and tiling layout |
| `Backspace` | Close others | Close all windows except current |

### Join Windows (Service Mode)

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + h` | Join left | Join with window on the left |
| `Alt + Shift + j` | Join down | Join with window below |
| `Alt + Shift + k` | Join up | Join with window above |
| `Alt + Shift + l` | Join right | Join with window on the right |

## Resize Mode

Enter resize mode with `Ctrl + Shift + r`:

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Enter` or `Esc` | Exit resize | Return to main mode |
| `-` | Resize smaller | Decrease size by 50px |
| `=` | Resize larger | Increase size by 50px |
| `Alt + -` | Resize smaller (large) | Decrease size by 200px |
| `Alt + =` | Resize larger (large) | Increase size by 200px |
| `h` | Resize width smaller | Decrease width by 50px |
| `j` | Resize height larger | Increase height by 50px |
| `k` | Resize height smaller | Decrease height by 50px |
| `l` | Resize width larger | Increase width by 50px |

## Automatic Application Assignment

### Work Applications (Workspace 1)

- **Slack** - Team communication
- **Zendesk Mail** - Email management
- **Zendesk Calendar** - Calendar application

### Development (Workspace T - Terminal)

- **Alacritty** - Primary terminal
- **WezTerm** - Alternative terminal

### IDE/Development (Workspace I/V)

- **IntelliJ IDEA** - Java/Kotlin development (Workspace I)
- **VS Code** - General code editing (Workspace V)

### Knowledge Management (Workspace Q)

- **Logseq** - Note-taking and knowledge base

### Floating Applications

These applications automatically use floating layout:

- **1Password** - Password manager
- **Finder** - File manager

## Configuration Settings

### Visual Settings

- **Gaps**: 4px inner and outer gaps between windows
- **Mouse follows focus**: Cursor moves when focus changes monitors
- **Status position**: Top of screen

### Behavior Settings

- **Auto-start**: Launches at login
- **Normalization**: Automatic container flattening and orientation
- **Default layout**: Tiles with auto orientation
- **Key mapping**: QWERTY layout

### Monitor Behavior

- **Auto orientation**: Wide monitors get horizontal layout, tall monitors
  get vertical
- **Workspace assignment**: Can force workspaces to specific monitors

## Tips and Workflows

### Productivity Workflows

1. **Development Setup**:
   - Terminal on workspace T
   - IDE on workspace I or V
   - Browser on workspace B
   - Communication on workspace 1

2. **Focus Mode**:
   - Use fullscreen (`Ctrl + Shift + f`) for distraction-free work
   - Utilize service mode (`Alt + Shift + ;`) for quick layout resets

3. **Multi-Monitor**:
   - Use `Alt + Shift + Tab` to move workspaces between monitors
   - Mouse automatically follows focus changes

### Common Operations

1. **Quick App Switching**:
   - Use workspace letters for app-specific spaces
   - `Alt + Tab` to return to previous workspace

2. **Layout Management**:
   - `Alt + /` for horizontal/vertical tile switching
   - Service mode `f` to toggle floating when needed

3. **Window Organization**:
   - Use join commands in service mode for complex layouts
   - Resize mode for precise window sizing

### Troubleshooting

1. **Layout Issues**:
   - Enter service mode (`Alt + Shift + ;`) and press `r` to reset

2. **Configuration Changes**:
   - Service mode `Esc` reloads configuration

3. **Stuck Windows**:
   - Use `Alt + Shift + Tab` to move workspace to different monitor
   - Try floating mode toggle in service mode

## Integration with Other Tools

### Terminal Integration

- Terminals automatically assigned to workspace T
- Works seamlessly with tmux for terminal multiplexing

### IDE Integration

- IntelliJ and VS Code have dedicated workspaces
- Floating apps (1Password, Finder) don't interfere with tiling

### macOS Integration

- Respects macOS spaces but provides superior tiling within each space
- Integrates with Mission Control and other macOS features
