# vim: set ft=zsh:
# Environment variables - loaded for all zsh instances

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Zsh configuration directory
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Editor preferences
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export PAGER="${PAGER:-less}"

# Less configuration
export LESS='-R --use-color -Dd+r$Du+b$'
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"

# History file location
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

# Language and locale
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Development tools
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export KUBECONFIG="${XDG_CONFIG_HOME}/kube/config"

# macOS specific
if [[ "$OSTYPE" == darwin* ]]; then
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
fi