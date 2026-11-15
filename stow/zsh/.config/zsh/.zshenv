# vim: set ft=zsh:
# shellcheck shell=bash disable=SC2148,SC1090,SC1091
# Environment variables - loaded for every zsh instance.
#
# zsh reaches this file in one of two ways:
#   1. ZDOTDIR is already set (e.g. by WezTerm), so zsh reads it directly.
#   2. The bootstrap block that bin/setup-zshenv.sh adds to ~/.zshenv sources it.
# ~/.zshenv itself stays an untracked, machine-managed file (JAMF/Netskope
# rewrite it), so it must never be a symlink into this repository.

# Load once per shell; not exported, so child shells load it again.
[[ -n "$_DOTFILES_ZSHENV_LOADED" ]] && return
_DOTFILES_ZSHENV_LOADED=1

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Zsh configuration directory
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

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

# When zsh read this file directly (case 1), it skipped ~/.zshenv. Source it
# so machine-managed settings such as the Netskope CA bundle still apply. Its
# bootstrap block sources this file again, which returns at the guard above.
if [[ -z "$_DOTFILES_FROM_HOME_ZSHENV" && -r "$HOME/.zshenv" ]]; then
    source "$HOME/.zshenv"
fi
