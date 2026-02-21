# vim: set ft=zsh:
# shellcheck shell=bash disable=SC2148,SC1090,SC1091,SC2142,SC2034,SC2154,SC1087,SC2206,SC2296,SC2207,SC2155,SC2086,SC2126,SC2245,SC1036,SC1088
# Performance Settings
# Configures performance-related options based on the detected environment.

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

# Export environment variables for use in other scripts
export ZSH_MINIMAL_MODE
