# vim: set ft=zsh:
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
