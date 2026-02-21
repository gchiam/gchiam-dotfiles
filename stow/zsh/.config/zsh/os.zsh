# vim: set ft=zsh:
# shellcheck shell=bash disable=SC2148,SC1090,SC1091,SC2142,SC2034,SC2154,SC1087,SC2206,SC2296,SC2207,SC2155,SC2086,SC2126,SC2245,SC1036,SC1088
# OS-specific Optimizations
# Sets OS-specific options for macOS and Linux.

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
