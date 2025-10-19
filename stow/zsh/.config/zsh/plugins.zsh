# shellcheck disable=SC2148
# vim: set ft=zsh:
# Plugin Loading
# Loads zsh plugins using antidote.

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
            # shellcheck source=/dev/null
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
                    ) & disown
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

# Export environment variables for use in other scripts
export ZSH_ANTIDOTE_LOADED ZSH_PLUGIN_LOAD_TIME
