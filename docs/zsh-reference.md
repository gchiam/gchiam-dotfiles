# Zsh Reference

Complete reference for the zsh configuration in this dotfiles repository.

## Table of Contents

- [Overview](#overview)
- [Configuration Structure](#configuration-structure)
- [Environment Variables](#environment-variables)
- [Plugin Management](#plugin-management)
- [Aliases Reference](#aliases-reference)
- [Functions Reference](#functions-reference)
- [Keybindings Reference](#keybindings-reference)
- [Completion System](#completion-system)
- [Environment Detection](#environment-detection)
- [Performance Features](#performance-features)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

## Overview

This zsh configuration provides a modern, efficient, and highly customizable shell environment optimized for development workflows. Key features include:

- **Modular architecture** - Configuration split into logical files
- **Environment-aware** - Different settings for work/personal/remote contexts
- **Performance optimized** - Lazy loading and minimal startup time
- **Plugin management** - Via antidote for fast plugin loading
- **XDG compliant** - Follows XDG Base Directory Specification
- **Vi-mode support** - Enhanced vi-mode with modern features
- **Rich completions** - Intelligent completion for development tools

## Quick Start

Most commonly used shortcuts and commands:

```bash
# Shell shortcuts
reload                             # Reload zsh configuration
zshrc                              # Edit main zsh config
aliases                            # Edit aliases file
functions                          # Edit functions file

# Navigation
..                                 # cd ..
md <dir>                           # mkdir -p and cd
-                                  # cd to previous directory

# Git workflow
gs                                 # git status
ga .                               # git add .
gcm "message"                      # git commit -m

# Quick utilities
weather                            # Current weather
serve                              # Start HTTP server
backup <file>                      # Create timestamped backup
show_env_info                      # Show environment details
```

## Configuration Structure

### File Organization

```
~/.zshenv                           # Environment variables (loaded first)
~/.config/zsh/
├── .zshrc                         # Main configuration file
├── .zprofile                      # Login shell configuration
├── aliases.zsh                    # Command aliases
├── completion.zsh                 # Completion configuration
├── environment.zsh                # Environment detection & settings
├── functions.zsh                  # Custom utility functions
└── keybindings.zsh               # Custom key bindings

~/.config/antidote/
└── .zsh_plugins.txt              # Plugin management
```

### Loading Order

1. `~/.zshenv` - Environment variables (all shells)
2. `~/.config/zsh/.zprofile` - Login shell setup (SSH agent, brew env)
3. `~/.config/zsh/.zshrc` - Interactive shell configuration
4. Modular files loaded by `.zshrc`:
   - `environment.zsh` (first - environment detection)
   - `functions.zsh`
   - `completion.zsh`
   - `aliases.zsh`
   - `keybindings.zsh`

## Environment Variables

### XDG Base Directory Specification

```bash
XDG_CONFIG_HOME="$HOME/.config"     # Configuration files
XDG_DATA_HOME="$HOME/.local/share"  # Data files
XDG_CACHE_HOME="$HOME/.cache"       # Cache files
XDG_STATE_HOME="$HOME/.local/state" # State files
ZDOTDIR="$HOME/.config/zsh"         # Zsh configuration directory
```

### Development Tools

```bash
EDITOR="nvim"                       # Default editor
VISUAL="nvim"                       # Visual editor
PAGER="less"                        # Default pager
HISTFILE="$XDG_STATE_HOME/zsh/history"  # History file location
DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"  # Docker config
KUBECONFIG="$XDG_CONFIG_HOME/kube/config"  # Kubernetes config
```

### Performance Variables

```bash
HISTSIZE=10000                      # In-memory history size
SAVEHIST=10000                     # Saved history size
ZSH_MINIMAL_MODE=false             # Performance mode flag
```

## Plugin Management

### Antidote Plugin Manager

Plugins are managed via antidote and defined in `~/.config/antidote/.zsh_plugins.txt`:

```bash
# Core completions
mattmc3/ez-compinit
zsh-users/zsh-completions kind:fpath path:src

# Enhanced features
Aloxaf/fzf-tab                     # FZF-powered completion menu
gradle/gradle-completion kind:fpath path:gradle-completion
jeffreytse/zsh-vi-mode            # Enhanced vi-mode
mattmc3/zfunctions                 # Additional functions
olets/zsh-abbr kind:defer          # Command abbreviations
rupa/z                             # Smart directory jumping
zdharma-continuum/fast-syntax-highlighting kind:defer
zsh-users/zsh-autosuggestions     # Command suggestions
zsh-users/zsh-history-substring-search

# Completion utilities
belak/zsh-utils path:completion
```

### Loading Strategy

- Plugins load via `environment.zsh` > `load_env_plugins()`
- Different plugin sets for work vs personal environments
- Deferred loading (`kind:defer`) for performance
- Conditional loading based on `ZSH_MINIMAL_MODE`

## Aliases Reference

### Core Commands

```bash
# Enhanced ls (with modern alternatives)
ls='ls --color=auto' # or 'ls -G' on macOS  # Colorized ls
ll='ls -alF'                       # Long format with indicators
la='ls -A'                         # Show hidden files
l='ls -CF'                         # Compact format
lh='ls -lah'                       # Long format, human readable
lt='ls -lart'                      # Sort by time, newest last

# Modern alternatives (if available)
# eza replaces ls with git integration
# bat replaces cat with syntax highlighting

# Safe operations
rm='rm -i'                         # Interactive remove
cp='cp -i'                         # Interactive copy
mv='mv -i'                         # Interactive move
ln='ln -i'                         # Interactive link
```

### Directory Navigation

```bash
..='cd ..'                         # Go up one level
...='cd ../..'                     # Go up two levels
....='cd ../../..'                 # Go up three levels
.....='cd ../../../..'             # Go up four levels
-='cd -'                           # Go to previous directory
md='mkdir -p'                      # Create directory and parents
```

### Git Shortcuts

```bash
g='git'                            # Git shortcut
ga='git add'                       # Add files
gaa='git add --all'                # Add all files
gb='git branch'                    # List branches
gbd='git branch -d'                # Delete branch
gc='git commit'                    # Commit
gcm='git commit -m'                # Commit with message
gca='git commit --amend'           # Amend last commit
gco='git checkout'                 # Checkout
gcb='git checkout -b'              # Create and checkout branch
gd='git diff'                      # Show diff
gds='git diff --staged'            # Show staged diff
gs='git s'                         # Status (uses git alias)
gl='git l'                         # Log (uses git alias)
gll='git lg'                       # Graph log (uses git alias)
gp='git push'                      # Push
gpl='git pull'                     # Pull
gst='git stash'                    # Stash changes
gstp='git stash pop'               # Pop stash
```

> **Note:** Many git shortcuts reference sophisticated git aliases configured via `bin/setup-git.sh`. See [Git Aliases Reference](git-aliases-reference.md) for detailed documentation of all available git aliases and their functionality.

### Development Tools

```bash
# Docker
d='docker'                         # Docker shortcut
dc='docker-compose'                # Docker compose
dcu='docker-compose up'            # Compose up
dcd='docker-compose down'          # Compose down
dps='docker ps'                    # List containers
dpsa='docker ps -a'                # List all containers
di='docker images'                 # List images
dex='docker exec -it'              # Execute in container
dlogs='docker logs -f'             # Follow logs

# Node.js/npm
ni='npm install'                   # Install packages
nr='npm run'                       # Run script
ns='npm start'                     # Start script
nt='npm test'                      # Test script
nu='npm update'                    # Update packages

# Yarn
y='yarn'                           # Yarn shortcut
ya='yarn add'                      # Add package
yr='yarn run'                      # Run script
ys='yarn start'                    # Start script
yt='yarn test'                     # Test script

# Python
py='python3'                       # Python 3
serve='python3 -m http.server'    # Quick HTTP server
jsonpp='python3 -m json.tool'     # JSON pretty print
```

### System Utilities

```bash
# Process management
ps='ps aux'                        # Process list
psg='ps aux | grep'                # Search processes
top='top -o %CPU'                  # Top by CPU usage

# Network
ping='ping -c 5'                   # Ping 5 times
pubip='curl -s https://ipinfo.io/ip'  # Public IP
localip="ifconfig | grep -E 'inet [0-9]' | grep -v 127.0.0.1 | awk '{print \$2}'"
```

### macOS Specific

```bash
finder='open -R'                   # Reveal in Finder
chrome='open -a "Google Chrome"'   # Open Chrome
code='open -a "Visual Studio Code"'  # Open VS Code
preview='open -a Preview'          # Open Preview
flush='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

# Homebrew
bu='brew update && brew upgrade'   # Update and upgrade
bc='brew cleanup'                  # Cleanup
bi='brew install'                  # Install package
br='brew remove'                   # Remove package
bs='brew search'                   # Search packages
bl='brew list'                     # List installed
bci='brew install --cask'          # Install cask
bcl='brew list --cask'             # List casks
bcs='brew search --cask'           # Search casks
```

### Global Aliases (Zsh-specific)

```bash
# Output redirection
alias -g L="| less"                # Pipe to less
alias -g LL="2>&1 | less"          # Pipe stderr+stdout to less
alias -g G='| grep'                # Pipe to grep
alias -g H='| head'                # Pipe to head
alias -g T='| tail'                # Pipe to tail
alias -g S='| sort'                # Pipe to sort
alias -g C='| wc -l'               # Count lines

# Error handling
alias -g NE="2> /dev/null"         # Suppress stderr
alias -g NUL="> /dev/null 2>&1"    # Suppress all output
alias -g DN=/dev/null              # Direct to null

# File patterns
alias -g Sk="*~(*.bz2|*.gz|*.tgz|*.zip|*.z)"  # Skip archives
```

## Functions Reference

### File Operations

```bash
mkcd <dir>                         # Create directory and cd into it
backup <file>                      # Create timestamped backup
extract <archive>                  # Extract various archive formats
ff <pattern>                       # Find files by name pattern
fd <pattern>                       # Find directories by name pattern
```

### System Utilities

```bash
killp <process>                    # Find and kill process by name
port <number>                      # Show what's running on port
dush [path]                        # Directory size, human readable
myip                               # Show local and public IP addresses
sysinfo                            # System information summary
topcpu [n]                         # Top processes by CPU usage (default: 10)
topmem [n]                         # Top processes by memory usage (default: 10)
```

### Development Tools

```bash
# Git helpers
git-branch-clean                   # Remove merged branches
git-last [n]                       # Show last n commits
git-size                           # Repository size

# Docker helpers
docker-clean                       # Clean containers, images, volumes
docker-stop-all                    # Stop all running containers

# Kubernetes helpers
k8s-ctx [context]                  # Get/set kubectl context
k8s-ns [namespace]                 # Get/set kubectl namespace
```

### Text Processing

```bash
json [file]                        # Pretty print JSON (stdin if no file)
urlencode <text>                   # URL encode text
urldecode <text>                   # URL decode text
b64encode <text>                   # Base64 encode
b64decode <text>                   # Base64 decode
upper <text>                       # Convert to uppercase
lower <text>                       # Convert to lowercase
```

### Utilities

```bash
weather [location]                 # Get weather forecast
serve [port]                       # Start HTTP server (default: 8000)
genpass [length]                   # Generate random password
note [text]                        # Quick note-taking system
```

## Keybindings Reference

### Navigation

```bash
Ctrl+A                             # Beginning of line
Ctrl+E                             # End of line
Ctrl+B                             # Backward character
Ctrl+F                             # Forward character
Alt+B                              # Backward word
Alt+F                              # Forward word
Ctrl+Left                          # Backward word (terminal)
Ctrl+Right                         # Forward word (terminal)
```

### Editing

```bash
Ctrl+D                             # Delete character
Ctrl+H                             # Backward delete character
Ctrl+W                             # Backward kill word
Ctrl+K                             # Kill line
Ctrl+U                             # Kill whole line
Ctrl+Y                             # Yank (paste)
Alt+Backspace                      # Backward kill word
```

### History

```bash
Ctrl+R                             # History search backward
Ctrl+S                             # History search forward
Ctrl+P                             # Previous command
Ctrl+N                             # Next command
Up/Down                            # History substring search
```

### Vi-mode (when enabled)

```bash
jj or jk                           # Escape to normal mode (from insert)
k/j                                # Navigate history (normal mode)
```

### Custom Shortcuts

```bash
# Command shortcuts
Alt+S                              # Add/remove sudo
Ctrl+X Ctrl+E                      # Edit command in $EDITOR
Ctrl+L                             # Clear screen, keep current line
Alt+.                              # Insert last argument
Alt+U                              # Undo
Alt+R                              # Redo
Alt+Q                              # Quote current line

# Git shortcuts
Ctrl+G Ctrl+S                      # git status
Ctrl+G Ctrl+A                      # git add .
Ctrl+G Ctrl+C                      # git commit -m ""

# Docker/Kubernetes
Ctrl+D Ctrl+P                      # docker ps
Ctrl+K Ctrl+P                      # kubectl get pods

# File operations
Alt+M                              # Quick mkdir and cd
Alt+F                              # Quick find
Alt+L                              # cd and ls
Alt+P                              # Toggle command | less
Alt+%                              # Search and replace in command
Alt+=                              # Quick calculator (if bc available)
```

### macOS Clipboard

```bash
Alt+C                              # Copy command to clipboard
Alt+V                              # Paste from clipboard
```

### FZF Integration

```bash
Ctrl+T                             # FZF directory navigation
Alt+T                              # FZF file selection
Ctrl+R                             # FZF history search (if available)
```

## Completion System

### Configuration

- **Case-insensitive** matching with smart patterns
- **Menu selection** with arrow key navigation
- **Caching** for improved performance
- **Grouping** by category with descriptions
- **Fuzzy matching** with error tolerance

### Enhanced Completions

```bash
# Development tools
kubectl                            # Kubernetes commands and resources
docker                             # Docker commands and containers
git                                # Git commands and branches
terraform                          # Terraform commands
vault                              # HashiCorp Vault
gh                                 # GitHub CLI

# Package managers
npm/yarn                           # Node.js package managers
brew                               # Homebrew packages
pip                                # Python packages
uv                                 # Python package installer

# Custom functions
mkcd                               # Directory completion
backup                             # File completion
killp                              # Process name completion
weather                            # City completion (predefined cities)
serve                              # Port number completion
genpass                            # Length completion
```

### SSH/SCP Completion

Automatically completes hosts from:
- `~/.ssh/config`
- `~/.ssh/known_hosts`
- Custom host groups

## Environment Detection

### Automatic Detection

The configuration automatically detects and adapts to different environments:

```bash
# Environment types
ZSH_ENV_WORK                       # Work environment (Zendesk)
ZSH_ENV_PERSONAL                   # Personal environment
ZSH_ENV_REMOTE                     # SSH/remote environment
ZSH_ENV_CONTAINER                  # Container environment

# Terminal types
ZSH_TERM_VSCODE                    # VS Code integrated terminal
ZSH_TERM_ITERM                     # iTerm2
ZSH_TERM_TERMINAL                  # macOS Terminal.app
ZSH_TERM_TMUX                      # tmux session
```

### Environment-specific Features

**Work Environment:**
- Work-specific aliases and functions
- Corporate proxy settings
- Work git configuration
- Different plugin set

**Remote Environment:**
- Minimal configuration for performance
- Reduced history size
- Simplified prompt
- Disabled resource-intensive features

**Container Environment:**
- Minimal plugin set
- Performance optimizations
- Container-aware settings

## Performance Features

### Startup Optimization

- **Lazy loading** of NVM, SDKMAN, and other tools
- **Conditional plugin loading** based on environment
- **Completion caching** for faster subsequent loads
- **Deferred loading** of syntax highlighting and other plugins

### Lazy Loading Examples

```bash
# NVM lazy loading
nvm() {
    unset -f nvm node npm
    # Load NVM on first use
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    nvm "$@"
}

# SDKMAN lazy loading
sdk() {
    unset -f sdk
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk "$@"
}
```

### Minimal Mode

When `ZSH_MINIMAL_MODE=true`:
- Disables resource-intensive plugins
- Uses simple prompt
- Reduces completion features
- Automatically enabled in remote/container environments

## Customization

### Adding Custom Aliases

Edit `~/.config/zsh/aliases.zsh`:

```bash
# Add personal aliases
alias myalias='my command'
```

### Adding Custom Functions

Edit `~/.config/zsh/functions.zsh`:

```bash
# Add custom function
my_function() {
    echo "Custom function"
}
```

### Adding Custom Keybindings

Edit `~/.config/zsh/keybindings.zsh`:

```bash
# Custom widget
my-widget() {
    # Widget implementation
}
zle -N my-widget
bindkey '^[x' my-widget  # Alt+X
```

### Environment-specific Configuration

Create files for specific environments:
- `~/.config/zsh/work-aliases.zsh` - Work-specific aliases
- `~/.config/zsh/work-functions.zsh` - Work-specific functions  
- `~/.config/antidote/.zsh_plugins_work.txt` - Work-specific plugins

Work environment is automatically detected by:
- `$ZENDESK_ENV` environment variable
- Username containing "zendesk"
- Presence of `~/.work_env` file

### Local Overrides

The configuration sources these files if they exist:
- `~/.bash_path` - Additional PATH entries
- `~/.bash_exports` - Environment variables
- `~/.bash_local` - Local configuration
- `~/.work_env` - Work environment marker
- `~/.work_proxy` - Work proxy settings

## Troubleshooting

### Common Issues

**Slow startup:**
```bash
# Check what's taking time
time zsh -i -c exit

# Enable minimal mode
export ZSH_MINIMAL_MODE=true
```

**Plugin issues:**
```bash
# Reload plugins
antidote bundle < ~/.config/antidote/.zsh_plugins.txt

# Check plugin loading
antidote list
```

**Completion problems:**
```bash
# Rebuild completion cache
rm -rf ~/.cache/zsh/zcompcache
compinit
```

**Key binding conflicts:**
```bash
# Show current bindings
bindkey | less

# Show specific key
bindkey "^R"
```

### Debug Mode

Enable debugging:
```bash
# Enable zsh debugging
set -x

# Enable plugin debugging
export ANTIDOTE_DEBUG=1
```

### Environment Information

Use the built-in function to check environment:
```bash
show_env_info
```

Example output:
```
=== Zsh Environment Information ===
Work Environment: false
Personal Environment: true
Remote Environment: false
Container Environment: false
Terminal: iTerm.app
Minimal Mode: false
OS Type: darwin22.0
====================================
```

### Reset Configuration

To reset to defaults:
```bash
# Remove cache
rm -rf ~/.cache/zsh

# Remove state
rm -rf ~/.local/state/zsh

# Reload configuration
source ~/.zshenv
source ~/.config/zsh/.zshrc
```

### Getting Help

- Use `Alt+?` to show all key bindings
- Use `Alt+H` to get help on current command
- Check function documentation: `which function_name`
- View configuration: `zshrc` (opens in editor)

---

For more information about specific components, see:
- [Setup Guide](setup-guide.md) - Installation and setup
- [Architecture](architecture.md) - Repository structure
- [Development Notes](development-notes.md) - Development practices