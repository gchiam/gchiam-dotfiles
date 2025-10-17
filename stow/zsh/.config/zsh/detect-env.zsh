# vim: set ft=zsh:
# Environment Detection
# Detects work, personal, remote, and container environments, and terminal program.

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

# Export environment variables for use in other scripts
export ZSH_ENV_WORK ZSH_ENV_PERSONAL ZSH_ENV_REMOTE ZSH_ENV_CONTAINER
export ZSH_TERM_VSCODE ZSH_TERM_ITERM ZSH_TERM_TERMINAL ZSH_TERM_TMUX
