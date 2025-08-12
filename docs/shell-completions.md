# Shell Completions

This document describes the shell completion system for dotfiles scripts.

## Overview

Shell completions provide tab-completion support for all custom dotfiles scripts,
making them easier to use and discover available options and commands.

## Supported Shells

- **Zsh**: Full completion support with descriptions and context-sensitive suggestions
- **Bash**: Basic completion support for commands and common options

## Installation

Completions are automatically installed when you run:

```bash
./bin/setup-completions.sh install
```

## Manual Installation

### Zsh

1. Copy completion files to your completions directory:

   ```bash
   cp stow/zsh/.config/zsh/completions/_* ~/.config/zsh/completions/
   ```

2. Add to your `.zshrc`:

   ```bash
   fpath=(~/.config/zsh/completions $fpath)
   autoload -U compinit && compinit
   ```

### Bash

1. Source the completion file in your `.bashrc`:

   ```bash
   source ~/.config/bash/completions/dotfiles
   ```

## Available Completions

### auto-sync.sh

- Commands: `sync`, `status`, `setup-automation`, `remove-automation`,
  `report`, `health`
- Options: `--dry-run`, `--force`, `--no-commit`, `--auto-push`,
  `--interval`, `--auto`

### check-compatibility.sh

- Options: `--system`, `--macos`, `--tools`, `--report`,
  `--recommendations`

### fresh-install.sh

- Options: `--profile`, `--repo`, `--dir`, `--skip-confirm`, `--verbose`
- Profiles: `full`, `minimal`, `developer`, `personal`, `work`,
  `experimental`, `interactive`

### health-check.sh

- Commands: `basic`, `shell`, `editor`, `terminal`, `window-manager`,
  `development`, `all`
- Options: `--fix`, `--report`, `--quiet`

### health-monitor.sh

- Commands: `report`, `start`, `stop`, `status`, `restart`,
  `setup-automation`, `logs`
- Options: `--interval`, `--no-alerts`
- Log types: `monitor`, `alerts`, `all`, `health`, `sync`

### optimize-repo.sh

- Options: `--analyze`, `--lfs`, `--migrate-lfs`, `--submodules`,
  `--cleanup`, `--all`

### performance-monitor.sh

- Commands: `startup`, `profile`, `system`, `config`, `plugins`,
  `recommendations`, `optimize`, `history`, `benchmark`, `all`
- Options: `--runs`, `--threshold`

### setup-git-hooks.sh

- Commands: `install`, `test`, `status`, `remove`, `help`

### setup-interactive.sh

- Options: `--profile`, `--backup`, `--yes`, `--categories`

### setup-profile.sh

- Commands: `list`, `show`, `apply`, `create`, `delete`, `interactive`,
  `status`, `backup`, `restore`
- Options: `--force`, `--backup`

### setup-stow.sh

- Options: `--target`, `--simulate`, `--verbose`, `--restow`, `--delete`
- Packages: Dynamically detects available stow packages

### setup.sh

- Options: `--force`, `--skip-brew`, `--skip-stow`, `--profile`

## Usage Examples

```bash
# Tab completion for commands
./bin/auto-sync.sh <TAB>
# Shows: sync  status  setup-automation  remove-automation  report  health

# Tab completion for options
./bin/health-check.sh --<TAB>
# Shows: --fix  --report  --quiet  --help  --verbose  --dry-run

# Context-sensitive completion
./bin/setup-profile.sh apply <TAB>
# Shows: full  minimal  developer  personal  work  experimental  interactive

# Option value completion
./bin/performance-monitor.sh --runs <TAB>
# Shows: 3  5  10  20
```

## Customization

You can customize completion behavior by modifying the completion files in:

- `stow/zsh/.config/zsh/completions/_dotfiles`
- Individual completion files: `stow/zsh/.config/zsh/completions/_<script>`

## Troubleshooting

### Completions not working

1. Ensure completion system is enabled:

   ```bash
   autoload -U compinit && compinit
   ```

2. Check if completion files are in the right location:

   ```bash
   echo $fpath
   ls ~/.config/zsh/completions/
   ```

3. Reload completions:

   ```bash
   exec zsh
   ```

### Debugging completions

1. Test completion loading:

   ```bash
   zsh -c "source ~/.config/zsh/completions/_dotfiles"
   ```

2. Enable completion debugging:

   ```bash
   zstyle ':completion:*' verbose yes
   ```

## Development

To add completions for new scripts:

1. Add the script to the `scripts` array in `_dotfiles`
2. Create a completion function `_script-name.sh()`
3. Add appropriate commands and options
4. Test with `./bin/setup-completions.sh test`

For more information about zsh completions, see the
[Zsh Completion System documentation](http://zsh.sourceforge.net/Doc/Release/Completion-System.html).
