# shellcheck disable=SC2148
# vim: set ft=zsh:
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
    # shellcheck disable=SC2034
    SAVEHIST=1000
else
    # Full configuration for local environments
    export ZSH_MINIMAL_MODE=false
    HISTSIZE=10000
    # shellcheck disable=SC2034
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
