# shellcheck disable=SC2148
# vim: set ft=zsh:
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
        # shellcheck source=/dev/null
        source "$HOME/.iterm2_shell_integration.zsh"
    fi
fi
