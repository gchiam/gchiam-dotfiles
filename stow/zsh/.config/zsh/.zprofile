# vim: set filetype=sh:
# shellcheck shell=bash disable=SC2148,SC1090,SC1091,SC2046,SC1004
# Login shell configuration - runs once per login session

#BEGIN ZETUP
eval "$( /opt/homebrew/bin/brew shellenv )"
[ "${commands[zetup]}" ] > /dev/null && eval "$( zetup env shell-exports)"
#END ZETUP

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

# SSH Agent Management (optimized)
# Only start ssh-agent if one isn't already running
if ! pgrep -x ssh-agent > /dev/null 2>&1; then
    # Start ssh-agent and export variables
    eval "$(ssh-agent -s)" > /dev/null
fi

# Add SSH keys if they exist and aren't already loaded
add_ssh_key() {
    local key_path="$1"
    if [[ -f "$key_path" ]]; then
        # Check if key is already loaded
        if ! ssh-add -l 2>/dev/null | grep -q "$key_path"; then
            ssh-add --apple-use-keychain "$key_path" 2>/dev/null
        fi
    fi
}

# Add common SSH keys
add_ssh_key "$HOME/.ssh/gchiam@zendesk.com"

# Clean up function
unset -f add_ssh_key
export NODE_USE_SYSTEM_CA=1
