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

if [[ ! -f "$HOME/.nscacert_combined.pem" ]]; then
    return
fi

# Begin JAMF Managed
# Common Dev-tools point to Netskope CA Bundle
export NETSKOPE_BUNDLE="$HOME/.nscacert_combined.pem"

# Generic Fallback & OpenSSL
export SSL_CERT_FILE="$NETSKOPE_BUNDLE"
export CA_BUNDLE="$NETSKOPE_BUNDLE"
export CURL_CA_BUNDLE="$NETSKOPE_BUNDLE"

# Python (Requests, Pip, httpx, urllib3)
export REQUESTS_CA_BUNDLE="$NETSKOPE_BUNDLE"
export PIP_CERT="$NETSKOPE_BUNDLE"

# Cloud & Infrastructure (AWS CLI, Boto3)
#export AWS_CA_BUNDLE="$NETSKOPE_BUNDLE"

# Node.js & Package Managers
export NODE_EXTRA_CA_CERTS="$NETSKOPE_BUNDLE"
export NODE_CAFILE="$NETSKOPE_BUNDLE"

# Git (Uses CAINFO for single files)
export GIT_SSL_CAINFO="$NETSKOPE_BUNDLE"

# Rust / Cargo
export CARGO_HTTP_CAINFO="$NETSKOPE_BUNDLE"

# Java / JVM
export JAVA_TOOL_OPTIONS="-Djavax.net.ssl.trustStore=$NETSKOPE_BUNDLE"
# End JAMF Managed


