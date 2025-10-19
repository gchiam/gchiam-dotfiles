# shellcheck disable=SC2148
# vim: set ft=zsh:
# Utility Functions
# Provides utility functions for lazy loading, environment information, and performance monitoring.

# Lazy-loading functions for performance optimization
_lazy_load_tool() {
    local tool="$1"
    local setup_func="$2"

    if ! [[ "$tool" =~ ^[A-Za-z0-9_]+$ ]] || ! [[ "$setup_func" =~ ^[A-Za-z0-9_]+$ ]]; then
        echo "Invalid tool or setup function name for lazy loading: $tool, $setup_func" >&2
        return 1
    fi
    
    # Create a wrapper function that loads the tool on first use
    # shellcheck disable=SC2145,SC2294
    eval "${tool}() {
        unfunction \"${tool}\"
        \"${setup_func}\"
        \"${tool}\" \"\\$@\"
    }"
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
            ) & disown
        fi
    fi
}

# Export environment variables for use in other scripts
export ZSH_PERFORMANCE_MONITORING
