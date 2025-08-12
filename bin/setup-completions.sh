#!/opt/homebrew/bin/bash
set -e

# Shell Completion Setup Script
# Generates and installs completion functions for all dotfiles scripts

# Colors (only if terminal supports them)
if [[ -t 1 ]] && command -v tput &> /dev/null && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    NC=''
fi

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# Configuration
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
COMPLETIONS_DIR="$HOME/.config/zsh/completions"
ZSH_COMPLETIONS_DIR="/opt/homebrew/share/zsh/site-functions"
CUSTOM_COMPLETIONS_DIR="$REPO_ROOT/stow/zsh/.config/zsh/completions"

# Create completions directory
setup_completions_dir() {
    print_header "Setting Up Completions Directory"
    
    # Create local completions directory
    mkdir -p "$COMPLETIONS_DIR"
    print_success "Created completions directory: $COMPLETIONS_DIR"
    
    # Create custom completions directory in repo
    mkdir -p "$CUSTOM_COMPLETIONS_DIR"
    print_success "Created custom completions directory: $CUSTOM_COMPLETIONS_DIR"
}

# Individual completion files are not needed
# The main _dotfiles completion function handles all scripts through the dispatcher
# and compdef statements in completion.zsh register the completion for each script
skip_individual_completions() {
    print_header "Skipping Individual Completion Files"
    print_info "Individual completion files are not needed"
    print_info "The main _dotfiles completion handles all scripts via dispatcher"
    print_success "Main completion provides all functionality"
}

# Generate bash completion (basic support)
generate_bash_completion() {
    print_header "Generating Bash Completion"
    
    local bash_completion_file="$HOME/.config/bash/completions/dotfiles"
    mkdir -p "$(dirname "$bash_completion_file")"
    
    cat > "$bash_completion_file" << 'EOF'
# Bash completion for dotfiles scripts
# Basic completion support for common commands and options

_dotfiles_completion() {
    local cur prev opts commands
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Common options for all scripts
    local common_opts="--help -h --verbose --dry-run"
    
    # Script-specific completions
    case "${COMP_WORDS[0]}" in
        auto-sync.sh)
            commands="sync status setup-automation remove-automation report health"
            opts="$common_opts --force --no-commit --auto-push --interval --auto"
            ;;
        check-compatibility.sh)
            opts="$common_opts --system --macos --tools --report --recommendations"
            ;;
        fresh-install.sh)
            opts="$common_opts --profile --repo --dir --skip-confirm"
            ;;
        health-check.sh)
            commands="basic shell editor terminal window-manager development all"
            opts="$common_opts --fix --report --quiet"
            ;;
        health-monitor.sh)
            commands="report start stop status restart setup-automation logs"
            opts="$common_opts --interval --no-alerts"
            ;;
        optimize-repo.sh)
            opts="$common_opts --analyze --lfs --migrate-lfs --submodules --cleanup --all"
            ;;
        performance-monitor.sh)
            commands="startup profile system config plugins recommendations optimize history benchmark all"
            opts="$common_opts --runs --threshold"
            ;;
        setup-git-hooks.sh)
            commands="install test status remove help"
            ;;
        setup-interactive.sh)
            opts="$common_opts --profile --backup --yes --categories"
            ;;
        setup-profile.sh)
            commands="list show apply create delete interactive status backup restore"
            opts="$common_opts --force --backup"
            ;;
        setup-stow.sh)
            opts="$common_opts --target --simulate --restow --delete"
            ;;
        setup.sh)
            opts="$common_opts --force --skip-brew --skip-stow --profile"
            ;;
    esac
    
    # Complete based on position
    if [[ ${COMP_CWORD} == 1 ]]; then
        COMPREPLY=( $(compgen -W "${commands} ${opts}" -- ${cur}) )
    else
        case "${prev}" in
            --profile)
                COMPREPLY=( $(compgen -W "full minimal developer personal work experimental interactive" -- ${cur}) )
                ;;
            --interval)
                COMPREPLY=( $(compgen -W "60 300 600 1800 3600" -- ${cur}) )
                ;;
            --runs)
                COMPREPLY=( $(compgen -W "3 5 10 20" -- ${cur}) )
                ;;
            --threshold)
                COMPREPLY=( $(compgen -W "1.0 2.0 3.0 5.0" -- ${cur}) )
                ;;
            logs)
                COMPREPLY=( $(compgen -W "monitor alerts all health sync" -- ${cur}) )
                ;;
            *)
                COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
                ;;
        esac
    fi
}

# Register completions for all dotfiles scripts
for script in auto-sync.sh check-compatibility.sh fresh-install.sh health-check.sh health-monitor.sh optimize-repo.sh performance-monitor.sh setup-git-hooks.sh setup-interactive.sh setup-profile.sh setup-stow.sh setup.sh; do
    complete -F _dotfiles_completion "$script"
    complete -F _dotfiles_completion "${script%.*}"
done
EOF
    
    print_success "Generated bash completion: $bash_completion_file"
}

# Install completions system-wide (if possible)
install_system_completions() {
    print_header "Installing System-Wide Completions"
    
    if [[ -w "$ZSH_COMPLETIONS_DIR" ]]; then
        print_info "Installing to system zsh completions directory..."
        
        # Copy main completion file
        cp "$CUSTOM_COMPLETIONS_DIR/_dotfiles" "$ZSH_COMPLETIONS_DIR/_dotfiles"
        print_success "Installed main completion file"
        
        # Copy individual completion files
        for comp_file in "$CUSTOM_COMPLETIONS_DIR"/_*; do
            if [[ -f "$comp_file" && "$(basename "$comp_file")" != "_dotfiles" ]]; then
                cp "$comp_file" "$ZSH_COMPLETIONS_DIR/"
                print_success "Installed $(basename "$comp_file")"
            fi
        done
    else
        print_warning "Cannot write to system completions directory: $ZSH_COMPLETIONS_DIR"
        print_info "Completions will be loaded from user directory"
    fi
}

# Update zsh configuration to load completions
update_zsh_config() {
    print_header "Updating Zsh Configuration"
    
    local zsh_config="$HOME/.config/zsh/.zshrc"
    local completion_config="# Custom completions setup
if [[ -d \"\$HOME/.config/zsh/completions\" ]]; then
    fpath=(\"\$HOME/.config/zsh/completions\" \$fpath)
fi

# Load custom dotfiles completions
if [[ -f \"\$HOME/.config/zsh/completions/_dotfiles\" ]]; then
    autoload -U _dotfiles
fi

# Enable completion system
autoload -U compinit && compinit -d \"\$HOME/.zcompdump\"

# Completion style configuration
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'"
    
    if [[ -f "$zsh_config" ]]; then
        # Check if completion config already exists
        if ! grep -q "Custom completions setup" "$zsh_config"; then
            echo -e "\n$completion_config" >> "$zsh_config"
            print_success "Added completion configuration to $zsh_config"
        else
            print_info "Completion configuration already exists in $zsh_config"
        fi
    else
        print_warning "Zsh config file not found: $zsh_config"
        print_info "Please add the completion configuration manually"
    fi
}

# Test completions
test_completions() {
    print_header "Testing Completions"
    
    print_info "Testing zsh completion loading..."
    
    # Test if completion files are syntactically correct
    for comp_file in "$CUSTOM_COMPLETIONS_DIR"/_*; do
        if [[ -f "$comp_file" ]]; then
            if zsh -c "source '$comp_file'" 2>/dev/null; then
                print_success "$(basename "$comp_file") loads correctly"
            else
                print_error "$(basename "$comp_file") has syntax errors"
            fi
        fi
    done
    
    print_info "To test completions interactively:"
    echo "  1. Restart your shell: exec zsh"
    echo "  2. Try tab completion: ./bin/auto-sync.sh <TAB>"
    echo "  3. Test with options: ./bin/health-check.sh --<TAB>"
}

# Generate completion documentation
generate_documentation() {
    print_header "Generating Completion Documentation"
    
    local doc_file="$REPO_ROOT/docs/shell-completions.md"
    
    cat > "$doc_file" << 'EOF'
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
- Commands: `sync`, `status`, `setup-automation`, `remove-automation`, `report`, `health`
- Options: `--dry-run`, `--force`, `--no-commit`, `--auto-push`, `--interval`, `--auto`

### check-compatibility.sh
- Options: `--system`, `--macos`, `--tools`, `--report`, `--recommendations`

### fresh-install.sh
- Options: `--profile`, `--repo`, `--dir`, `--skip-confirm`, `--verbose`
- Profiles: `full`, `minimal`, `developer`, `personal`, `work`, `experimental`, `interactive`

### health-check.sh
- Commands: `basic`, `shell`, `editor`, `terminal`, `window-manager`, `development`, `all`
- Options: `--fix`, `--report`, `--quiet`

### health-monitor.sh
- Commands: `report`, `start`, `stop`, `status`, `restart`, `setup-automation`, `logs`
- Options: `--interval`, `--no-alerts`
- Log types: `monitor`, `alerts`, `all`, `health`, `sync`

### optimize-repo.sh
- Options: `--analyze`, `--lfs`, `--migrate-lfs`, `--submodules`, `--cleanup`, `--all`

### performance-monitor.sh
- Commands: `startup`, `profile`, `system`, `config`, `plugins`, `recommendations`, `optimize`, `history`, `benchmark`, `all`
- Options: `--runs`, `--threshold`

### setup-git-hooks.sh
- Commands: `install`, `test`, `status`, `remove`, `help`

### setup-interactive.sh
- Options: `--profile`, `--backup`, `--yes`, `--categories`

### setup-profile.sh
- Commands: `list`, `show`, `apply`, `create`, `delete`, `interactive`, `status`, `backup`, `restore`
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

For more information about zsh completions, see the [Zsh Completion System documentation](http://zsh.sourceforge.net/Doc/Release/Completion-System.html).
EOF
    
    print_success "Generated completion documentation: $doc_file"
}

# Show completion status
show_status() {
    print_header "Shell Completion Status"
    
    # Check zsh completions
    print_info "Zsh completions:"
    if [[ -d "$COMPLETIONS_DIR" ]]; then
        local comp_count
        comp_count=$(find "$COMPLETIONS_DIR" -name '_*' -type f 2>/dev/null | wc -l | xargs)
        print_success "Local completions directory exists ($comp_count files)"
        
        for comp_file in "$COMPLETIONS_DIR"/_*; do
            if [[ -f "$comp_file" ]]; then
                echo "  ✓ $(basename "$comp_file")"
            fi
        done
    else
        print_warning "Local completions directory not found"
    fi
    
    # Check system completions
    if [[ -f "$ZSH_COMPLETIONS_DIR/_dotfiles" ]]; then
        print_success "System-wide completions installed"
    else
        print_info "System-wide completions not installed"
    fi
    
    # Check bash completions
    print_info "Bash completions:"
    if [[ -f "$HOME/.config/bash/completions/dotfiles" ]]; then
        print_success "Bash completions available"
    else
        print_warning "Bash completions not found"
    fi
    
    # Check zsh configuration
    if [[ -f "$HOME/.config/zsh/.zshrc" ]] && grep -q "Custom completions setup" "$HOME/.config/zsh/.zshrc"; then
        print_success "Zsh configuration includes completion setup"
    else
        print_warning "Zsh configuration may not include completion setup"
    fi
}

# Remove completions
remove_completions() {
    print_header "Removing Shell Completions"
    
    # Remove local completions
    if [[ -d "$COMPLETIONS_DIR" ]]; then
        rm -f "$COMPLETIONS_DIR"/_*
        print_success "Removed local completion files"
    fi
    
    # Remove system completions
    if [[ -w "$ZSH_COMPLETIONS_DIR" ]]; then
        rm -f "$ZSH_COMPLETIONS_DIR"/_dotfiles
        rm -f "$ZSH_COMPLETIONS_DIR"/_auto-sync
        rm -f "$ZSH_COMPLETIONS_DIR"/_check-compatibility
        rm -f "$ZSH_COMPLETIONS_DIR"/_fresh-install
        rm -f "$ZSH_COMPLETIONS_DIR"/_health-*
        rm -f "$ZSH_COMPLETIONS_DIR"/_optimize-repo
        rm -f "$ZSH_COMPLETIONS_DIR"/_performance-monitor
        rm -f "$ZSH_COMPLETIONS_DIR"/_setup-*
        print_success "Removed system completion files"
    fi
    
    # Remove bash completions
    rm -f "$HOME/.config/bash/completions/dotfiles"
    print_success "Removed bash completions"
}

# Show help
show_help() {
    cat << EOF
Shell Completion Setup Script

Usage: $0 [command]

Commands:
    install         Generate and install all completion files (default)
    test           Test completion file syntax
    status         Show completion installation status
    remove         Remove all completion files
    generate-docs  Generate completion documentation
    help           Show this help message

This script sets up shell completion for all dotfiles scripts, providing:
    • Tab completion for commands and options
    • Context-sensitive argument completion
    • Support for both Zsh and Bash
    • Automatic installation and configuration

Files created:
    • ~/.config/zsh/completions/_dotfiles (main completion)
    • ~/.config/zsh/completions/_<script> (individual completions)
    • ~/.config/bash/completions/dotfiles (bash support)
    • docs/shell-completions.md (documentation)

The completion system provides intelligent suggestions for:
    • Available commands and subcommands
    • Command-line options and flags
    • Profile names and configuration values
    • File paths and directories
    • Log types and other contextual values

Examples:
    $0 install      # Set up all completions
    $0 test        # Verify completion syntax
    $0 status      # Check installation status
EOF
}

# Main function
main() {
    local command="${1:-install}"
    
    case "$command" in
        "install")
            setup_completions_dir
            skip_individual_completions
            generate_bash_completion
            install_system_completions
            update_zsh_config
            generate_documentation
            show_status
            echo
            print_success "Shell completions installed successfully!"
            print_info "Restart your shell to enable completions: exec zsh"
            ;;
        "test")
            test_completions
            ;;
        "status")
            show_status
            ;;
        "remove")
            remove_completions
            ;;
        "generate-docs")
            generate_documentation
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
