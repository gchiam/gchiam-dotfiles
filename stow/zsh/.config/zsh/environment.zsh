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
        
        # Load plugins with antidote with performance tracking
        local antidote_path="${HOMEBREW_PREFIX:-/opt/homebrew}/share/antidote/antidote.zsh"
        if [[ -f "$antidote_path" ]] && [[ -f "$plugins_file" ]]; then
            source "$antidote_path"
            
            # Track plugin loading time if performance monitoring is enabled
            local plugin_start_time
            if [[ "$ZSH_PERFORMANCE_MONITORING" == true ]] && [[ -n "$EPOCHREALTIME" ]]; then
                plugin_start_time="$EPOCHREALTIME"
            fi
            
            if antidote load "$plugins_file" 2>/dev/null; then
                export ZSH_ANTIDOTE_LOADED=true
                
                # Log plugin loading time
                if [[ "$ZSH_PERFORMANCE_MONITORING" == true ]] && [[ -n "$plugin_start_time" ]]; then
                    local plugin_end_time="$EPOCHREALTIME"
                    local plugin_load_time=$(( plugin_end_time - plugin_start_time ))
                    export ZSH_PLUGIN_LOAD_TIME="$plugin_load_time"
                    
                    # Log plugin performance asynchronously
                    (
                        echo "$(date '+%Y-%m-%d %H:%M:%S') Plugin loading: ${plugin_load_time}s ($(basename "$plugins_file" .txt)) ($$)" >> "$HOME/.dotfiles-performance.log" 2>/dev/null
                    ) &!
                fi
            else
                export ZSH_ANTIDOTE_LOADED=false
                echo "Warning: Antidote plugin loading failed" >&2
            fi
        else
            export ZSH_ANTIDOTE_LOADED=false
            [[ ! -f "$antidote_path" ]] && echo "Warning: Antidote not found at $antidote_path" >&2
            [[ ! -f "$plugins_file" ]] && echo "Warning: Plugin file not found at $plugins_file" >&2
        fi
    fi
}

# Lazy-loading functions for performance optimization
_lazy_load_tool() {
    local tool="$1"
    local setup_func="$2"
    
    # Create a wrapper function that loads the tool on first use
    eval "${tool}() {
        unfunction ${tool}
        ${setup_func}
        ${tool} \"\$@\"
    }"
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
    echo "Antidote Loaded: ${ZSH_ANTIDOTE_LOADED:-unknown}"
    if [[ "$ZSH_ANTIDOTE_LOADED" == true ]]; then
        local plugins_file="${XDG_CONFIG_HOME:-$HOME/.config}/antidote/.zsh_plugins.txt"
        if [[ "$ZSH_ENV_WORK" == true ]] && [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/antidote/.zsh_plugins_work.txt" ]]; then
            plugins_file="${XDG_CONFIG_HOME:-$HOME/.config}/antidote/.zsh_plugins_work.txt"
        fi
        echo "Plugin File: $(basename "$plugins_file")"
        if [[ -n "$ZSH_PLUGIN_LOAD_TIME" ]]; then
            echo "Plugin Load Time: ${ZSH_PLUGIN_LOAD_TIME}s"
        fi
    fi
    echo "OS Type: $OSTYPE"
    echo "=================================="
}

# Performance monitoring integration
setup_performance_monitoring() {
    # Optional performance monitoring if enabled and not in minimal mode
    if [[ "$ZSH_PERFORMANCE_MONITORING" == true ]] && [[ "$ZSH_MINIMAL_MODE" == false ]]; then
        # Record shell startup time for performance tracking
        local perf_script
        # Find performance-monitor.sh in common locations
        for path in "$HOME/bin/performance-monitor.sh" "$HOME/.local/bin/performance-monitor.sh" "$HOME/projects/gchiam-dotfiles/bin/performance-monitor.sh" "$HOME/.dotfiles/bin/performance-monitor.sh"; do
            if [[ -x "$path" ]]; then
                perf_script="$path"
                break
            fi
        done
        
        if [[ -n "$ZSH_STARTUP_TIME" ]] && [[ -n "$perf_script" ]]; then
            # Log startup time asynchronously to avoid blocking shell startup
            (
                echo "$(date '+%Y-%m-%d %H:%M:%S') Shell startup: ${ZSH_STARTUP_TIME}s ($$)" >> "$HOME/.dotfiles-performance.log" 2>/dev/null
            ) &!
        fi
    fi
}

# Initialize environment-specific configurations
init_environment() {
    load_env_plugins
    
    # Note: vi mode is enabled in keybindings.zsh
    # zsh-vi-mode plugin will override if it loads successfully
    
    _lazy_load_tool git setup_git_config
    _lazy_load_tool ssh setup_ssh_config
    setup_performance_monitoring
}

# Export environment variables for use in other scripts
export ZSH_ENV_WORK ZSH_ENV_PERSONAL ZSH_ENV_REMOTE ZSH_ENV_CONTAINER ZSH_MINIMAL_MODE
export ZSH_TERM_VSCODE ZSH_TERM_ITERM ZSH_TERM_TERMINAL ZSH_TERM_TMUX ZSH_ANTIDOTE_LOADED
export ZSH_PERFORMANCE_MONITORING ZSH_PLUGIN_LOAD_TIME

# Auto-initialize on source
init_environment
