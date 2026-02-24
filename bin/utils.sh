#!/bin/bash
# Shared utility functions for dotfiles scripts

# Get XDG compliant path with standard defaults
# Usage: get_xdg_path <TYPE> [FALLBACK]
# Types: CONFIG, DATA, CACHE, STATE
get_xdg_path() {
    local type="${1:-}"
    local fallback="${2:-}"

    case "$type" in
        CONFIG)
            echo "${XDG_CONFIG_HOME:-$HOME/.config}"
            ;;
        DATA)
            echo "${XDG_DATA_HOME:-$HOME/.local/share}"
            ;;
        CACHE)
            echo "${XDG_CACHE_HOME:-$HOME/.cache}"
            ;;
        STATE)
            echo "${XDG_STATE_HOME:-$HOME/.local/state}"
            ;;
        *)
            if [[ -n "$fallback" ]]; then
                echo "$fallback"
            else
                return 1
            fi
            ;;
    esac
}

# Ensure directory exists for a given file path
# Usage: ensure_dir <FILE_PATH>
ensure_dir() {
    local file_path="$1"
    local dir_path
    dir_path=$(dirname "$file_path")
    mkdir -p "$dir_path"
}
