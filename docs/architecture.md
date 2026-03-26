# 🏗️ Architecture Overview

This document describes the overall architecture and structure of the
dotfiles repository.

## 🧭 Navigation

| Direction    | Link                                 | Description                   |
| ------------ | ------------------------------------ | ----------------------------- |
| ⬅️ **Back**  | [Main README](../README.md)          | Return to repository overview |
| 🚀 **Setup** | [Installation Guide](setup-guide.md) | Get started with installation |
| 📋 **Next**  | [Workflow Guide](workflow-guide.md)  | Learn daily usage patterns    |

---

## 🗂️ Repository Structure Diagram

```text
~/.dotfiles/                          # Main dotfiles repository
├── 📁 bin/                          # 🔧 Setup and utility scripts
│   ├── setup*.sh                    #    Installation scripts
│   ├── health*.sh                   #    Health monitoring
│   ├── performance*.sh              #    Performance tools
│   └── auto*.sh                     #    Automation scripts
├── 📁 docs/                         # 📚 Comprehensive documentation
│   ├── setup-guide.md              #    Installation procedures
│   ├── workflow-guide.md            #    Daily usage patterns
│   ├── automation-guide.md          #    Advanced automation
│   └── *-reference.md               #    Tool-specific guides
├── 📁 stow/                         # 🏠 Configuration packages (29+ tools)
│   ├── nvim/                        #    Neovim (LazyVim)
│   ├── zsh/                         #    Zsh shell environment
│   ├── tmux/                        #    Terminal multiplexer
│   ├── git/                         #    Git configuration
│   ├── alacritty/, kitty/, wezterm/ #    Terminal emulators
│   ├── aerospace/                   #    Window manager
│   └── ...                          #    Other tool configs
├── 📁 external/                     # 🎨 External dependencies
│   ├── catppuccin/                  #    Theme configurations
│   └── tmux-plugins/                #    tmux plugin sources
├── 📁 raycast/                      # 🚀 Custom Raycast extensions
└── 📁 terminfo/                     # 🖥️  Terminal compatibility files
```

## 🏛️ Core Structure Components

### 🏠 Configuration Management (`stow/`)

The heart of the dotfiles system - 29+ tool configurations organized as
Stow packages:

#### 🔧 Development Tools

- `nvim/` - Neovim with LazyVim distribution
- `tmux/` - Terminal multiplexer with plugins
- `git/` - Enhanced git configuration with delta
- `gh-dash/` - GitHub CLI dashboard

#### 🐚 Shell & Terminal

- `zsh/` - Modular zsh configuration with antidote
- `alacritty/`, `kitty/`, `wezterm/` - Terminal emulators
- `starship/` - Cross-shell prompt

#### 🖥️ macOS Integration

- `aerospace/` - Tiling window manager
- `karabiner/` - Keyboard customization
- `raycast/` - Application launcher extensions

#### 📦 Package Management

- `brew/` - Homebrew package definitions
- Custom Brewfiles for work and personal environments

## ⚙️ Configuration Management

Uses GNU Stow for symlink management. Each application configuration lives
in its own `stow/` subdirectory and gets symlinked to the appropriate
location in `$HOME` during setup.

## 🔑 Key Configuration Categories

- **Development**: `nvim/`, `tmux/`, `git/`, `gh-dash/`
- **Shell/Terminal**: `zsh/`, `alacritty/`, `kitty/`, `wezterm/`,
  `starship/`
- **macOS Tools**: `aerospace/`, `karabiner/`, `raycast/`
- **Package Management**: `brew/` with functional fragments
  (`base.brew`, `dev.brew`, `ui.brew`, `work.brew`)
- **Scripts**: `custom-bin/` with enhanced utilities for Docker, colors,
  macOS

## 🔧 Enhanced Script Management

The `stow/custom-bin/bin/` directory contains improved utilities:

- **Docker cleanup scripts** with error handling and confirmation prompts
- **Color palette display** with customizable columns
- **macOS dark mode detection** with cross-platform checks
- All scripts include `--help` flags and robust error handling

## 🎨 Theme System

Consistent Catppuccin theming across all applications via
`external/catppuccin/` configurations.

## 📁 XDG Compliance Standards

The project adheres to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
to keep the `$HOME` directory clean:

- **Configuration**: `${XDG_CONFIG_HOME:-$HOME/.config}`
- **Data**: `${XDG_DATA_HOME:-$HOME/.local/share}`
- **State/Logs**: `${XDG_STATE_HOME:-$HOME/.local/state}`
- **Cache**: `${XDG_CACHE_HOME:-$HOME/.cache}`

All custom scripts and shell configurations are designed to use these paths
with standard defaults when environment variables are not explicitly set.

## 🍎 macOS-Specific Components

### 🪟 Window Management

- **AeroSpace** (`stow/aerospace/`) - Tiling window manager
- **Yabai/SKHD** - Alternative window management (legacy)

### ⚙️ System Customization

- **Karabiner-Elements** - Keyboard customization
- **Raycast** - Application launcher with custom TypeScript extensions

## 📦 Package Dependencies

- Modular package lists are split into functional fragments: `base.brew`,
  `dev.brew`, `ui.brew`, and `work.brew`
- `~/.Brewfile` is generated by `bin/generate-brewfile.sh` by concatenating
  the relevant fragments for the chosen profile (`minimal`, `personal`, `work`,
  or `all`); multiple profiles can be combined with comma separation
- Version managers (asdf, nvm) handle language runtimes

## 🚀 Custom Extensions

Raycast extensions in `raycast/` are TypeScript-based Node.js projects with
their own package.json files.
