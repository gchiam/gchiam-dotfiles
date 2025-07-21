# vim: set ft=zsh:
# Environment-specific Configuration
# Conditional loading based on system, terminal, and work environment

# Detect environment
ZSH_ENV_WORK=false
ZSH_ENV_PERSONAL=true
ZSH_ENV_REMOTE=false
ZSH_ENV_CONTAINER=false

# Work environment detection
if [[ -n "$ZENDESK_ENV" ]] || [[ "$USER" =~ .*zendesk.* ]] || [[ -f "$HOME/.work_env" ]]; then
    ZSH_ENV_WORK=true
    ZSH_ENV_PERSONAL=false
fi

# Remote environment detection (SSH)
if [[ -n "$SSH_CONNECTION" ]] || [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    ZSH_ENV_REMOTE=true
fi

# Container detection
if [[ -f /.dockerenv ]] || [[ -n "$KUBERNETES_SERVICE_HOST" ]] || [[ "$container" == "podman" ]]; then
    ZSH_ENV_CONTAINER=true
fi

# Terminal detection
ZSH_TERM_VSCODE=false
ZSH_TERM_ITERM=false
ZSH_TERM_TERMINAL=false
ZSH_TERM_TMUX=false

case "$TERM_PROGRAM" in
    "vscode") ZSH_TERM_VSCODE=true ;;
    "iTerm.app") ZSH_TERM_ITERM=true ;;
    "Apple_Terminal") ZSH_TERM_TERMINAL=true ;;
esac

[[ -n "$TMUX" ]] && ZSH_TERM_TMUX=true

# Performance settings based on environment
if [[ "$ZSH_ENV_REMOTE" == true ]] || [[ "$ZSH_ENV_CONTAINER" == true ]]; then
    # Minimal configuration for remote/container environments
    export ZSH_MINIMAL_MODE=true
    # Disable resource-intensive features
    export ZSH_DISABLE_COMPFIX=true
    # Reduce history size
    HISTSIZE=1000
    SAVEHIST=1000
else
    # Full configuration for local environments
    export ZSH_MINIMAL_MODE=false
    HISTSIZE=10000
    SAVEHIST=10000
fi

# History options (moved from .zshrc)
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY          # Record timestamp in history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_FIND_NO_DUPS         # Don't display duplicates in search
setopt HIST_IGNORE_ALL_DUPS      # Remove all earlier duplicate lines
setopt HIST_IGNORE_SPACE         # Don't record lines starting with space
setopt HIST_REDUCE_BLANKS        # Remove extra blanks from commands
setopt HIST_SAVE_NO_DUPS         # Don't save duplicates
setopt HIST_VERIFY               # Show command before executing from history

# Work-specific configurations
if [[ "$ZSH_ENV_WORK" == true ]]; then
    # Work-specific aliases
    if [[ -f "${ZDOTDIR:-$HOME/.config/zsh}/work-aliases.zsh" ]]; then
        source "${ZDOTDIR:-$HOME/.config/zsh}/work-aliases.zsh"
    fi
    
    # Work-specific functions
    if [[ -f "${ZDOTDIR:-$HOME/.config/zsh}/work-functions.zsh" ]]; then
        source "${ZDOTDIR:-$HOME/.config/zsh}/work-functions.zsh"
    fi
    
    # Work proxy settings (if needed)
    if [[ -f "$HOME/.work_proxy" ]]; then
        source "$HOME/.work_proxy"
    fi
fi

# Terminal-specific configurations
if [[ "$ZSH_TERM_VSCODE" == true ]]; then
    # VS Code integrated terminal optimizations
    export TERM=xterm-256color
    # Disable oh-my-posh in VS Code for better performance
    export ZSH_DISABLE_PROMPT=true
fi

if [[ "$ZSH_TERM_ITERM" == true ]]; then
    # iTerm2 specific features
    # Enable iTerm2 shell integration if available
    if [[ -f "$HOME/.iterm2_shell_integration.zsh" ]]; then
        source "$HOME/.iterm2_shell_integration.zsh"
    fi
fi

# Performance mode for slow systems
if [[ "$ZSH_MINIMAL_MODE" == true ]]; then
    # Disable expensive features
    export ZSH_DISABLE_COMPFIX=true
    export DISABLE_AUTO_UPDATE=true
    export DISABLE_AUTO_TITLE=true
    export DISABLE_MAGIC_FUNCTIONS=true
    
    # Simplified prompt
    if [[ "$ZSH_DISABLE_PROMPT" != true ]]; then
        PS1='%n@%m:%~%# '
    fi
fi

# OS-specific optimizations
case "$OSTYPE" in
    darwin*)
        # macOS specific settings
        if [[ "$ZSH_ENV_WORK" == true ]]; then
            # Work-specific macOS settings
            export BROWSER="open -a 'Google Chrome'"
        fi
        
        # Homebrew optimizations
        if [[ -d "/opt/homebrew" ]]; then
            export HOMEBREW_PREFIX="/opt/homebrew"
        elif [[ -d "/usr/local/Homebrew" ]]; then
            export HOMEBREW_PREFIX="/usr/local"
        fi
        ;;
        
    linux*)
        # Linux specific settings
        if [[ "$ZSH_ENV_REMOTE" == true ]]; then
            # Remote Linux optimizations
            export TERM=screen-256color
        fi
        ;;
esac

# Load environment-specific plugins
load_env_plugins() {
    if [[ "$ZSH_MINIMAL_MODE" == false ]]; then
        # Full plugin set for local development
        local plugins_file="${XDG_CONFIG_HOME:-$HOME/.config}/antidote/.zsh_plugins.txt"
        
        if [[ "$ZSH_ENV_WORK" == true ]] && [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/antidote/.zsh_plugins_work.txt" ]]; then
            plugins_file="${XDG_CONFIG_HOME:-$HOME/.config}/antidote/.zsh_plugins_work.txt"
        fi
        
        # Load plugins with antidote (simplified approach like original)
        local antidote_path="${HOMEBREW_PREFIX:-/opt/homebrew}/share/antidote/antidote.zsh"
        if [[ -f "$antidote_path" ]] && [[ -f "$plugins_file" ]]; then
            source "$antidote_path"
            antidote load "$plugins_file"
        fi
    fi
}

# Conditional loading functions
load_development_tools() {
    if [[ "$ZSH_ENV_CONTAINER" == false ]] && [[ "$ZSH_MINIMAL_MODE" == false ]]; then
        # Load development tools only in non-container environments
        
        # Docker completion (if Docker is available)
        if command -v docker >/dev/null && [[ -f /usr/local/etc/bash_completion.d/docker ]]; then
            source /usr/local/etc/bash_completion.d/docker
        fi
        
        # Kubernetes tools (completion handled by completion.zsh)
        
        # Terraform completion
        if command -v terraform >/dev/null; then
            autoload -U +X bashcompinit && bashcompinit
            complete -o nospace -C terraform terraform
        fi
    fi
}

# Git configuration based on environment
setup_git_config() {
    if [[ "$ZSH_ENV_WORK" == true ]]; then
        # Work git configuration
        if [[ -f "$HOME/.gitconfig-work" ]]; then
            git config --global include.path ~/.gitconfig-work
        fi
    else
        # Personal git configuration
        if [[ -f "$HOME/.gitconfig-personal" ]]; then
            git config --global include.path ~/.gitconfig-personal
        fi
    fi
}

# SSH configuration based on environment
setup_ssh_config() {
    if [[ "$ZSH_ENV_WORK" == true ]]; then
        # Use work SSH config if available
        if [[ -f "$HOME/.ssh/config_work" ]]; then
            export SSH_CONFIG_FILE="$HOME/.ssh/config_work"
        fi
    fi
}

# Environment information function
show_env_info() {
    echo "=== Zsh Environment Information ==="
    echo "Work Environment: $ZSH_ENV_WORK"
    echo "Personal Environment: $ZSH_ENV_PERSONAL"
    echo "Remote Environment: $ZSH_ENV_REMOTE"
    echo "Container Environment: $ZSH_ENV_CONTAINER"
    echo "Terminal: $TERM_PROGRAM"
    echo "Minimal Mode: $ZSH_MINIMAL_MODE"
    echo "OS Type: $OSTYPE"
    echo "=================================="
}

# Initialize environment-specific configurations
init_environment() {
    load_env_plugins
    load_development_tools
    setup_git_config
    setup_ssh_config
}

# Export environment variables for use in other scripts
export ZSH_ENV_WORK ZSH_ENV_PERSONAL ZSH_ENV_REMOTE ZSH_ENV_CONTAINER ZSH_MINIMAL_MODE
export ZSH_TERM_VSCODE ZSH_TERM_ITERM ZSH_TERM_TERMINAL ZSH_TERM_TMUX

# Auto-initialize on source
init_environment