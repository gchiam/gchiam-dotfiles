# vim: set ft=zsh:
# shellcheck shell=bash disable=SC2148,SC1090,SC1091,SC2142,SC2034,SC2154,SC1087,SC2206,SC2296,SC2207,SC2155,SC2086,SC2126,SC2245,SC1036,SC1088
# Terminal-specific Configurations
# Sets terminal-specific options for VS Code and iTerm2.

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
