# vim: set ft=zsh:
# Zsh Completion Configuration
# Enhanced completion settings and custom completions

# Load modern completion system
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Enable bash completion compatibility
autoload -U +X bashcompinit && bashcompinit

# Completion caching
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Case-insensitive completion
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

# Completion menu behavior
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Group completions by category
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'

# Complete options and arguments
zstyle ':completion:*' completer _complete _match _approximate _ignored
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Fuzzy matching
zstyle ':completion:*:approximate:*' max-errors 2

# Directory completion
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' special-dirs true

# Process completion
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# SSH/SCP completion
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr

# Known hosts completion
if [[ -r ~/.ssh/config ]]; then
    zstyle ':completion:*:ssh:*' hosts $(awk '/^Host / && !/\*/ {print $2}' ~/.ssh/config)
fi
if [[ -r ~/.ssh/known_hosts ]]; then
    zstyle ':completion:*:ssh:*' hosts $(awk '{print $1}' ~/.ssh/known_hosts | tr ',' '\n' | sort -u)
fi

# Git completion enhancements
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-branch:*' sort false

# Docker completion
if command -v docker >/dev/null; then
    zstyle ':completion:*:docker:*' option-stacking yes
    zstyle ':completion:*:docker-*:*' option-stacking yes
fi

# Kubernetes completion
if command -v kubectl >/dev/null; then
    source <(kubectl completion zsh 2>/dev/null)
    compdef __start_kubectl k
fi

# Custom completion for common commands
_mkcd() {
    _arguments '1:directory:_directories'
}
compdef _mkcd mkcd

_backup() {
    _arguments '1:file:_files'
}
compdef _backup backup

_killp() {
    _arguments '1:process name:_process_names'
}
compdef _killp killp

_extract() {
    _arguments '1:archive:_files -g "*.{tar.gz,tar.bz2,tar.xz,zip,rar,7z,gz,bz2,tgz,tbz2,txz}"'
}
compdef _extract extract

_port() {
    _arguments '1:port number:'
}
compdef _port port

_serve() {
    _arguments '1:port number:(8000 3000 4000 5000 8080 8888 9000)'
}
compdef _serve serve

# Custom completion for weather function
_weather() {
    local cities
    cities=(
        "New York" "London" "Tokyo" "Paris" "Berlin" "Sydney"
        "San Francisco" "Los Angeles" "Chicago" "Boston"
        "Vancouver" "Toronto" "Montreal"
        "Singapore" "Kuching"
    )
    _describe 'cities' cities
}
compdef _weather weather

# Completion for git functions
_git-last() {
    _arguments '1:count:(5 10 15 20 25 50)'
}
compdef _git-last git-last

# Docker custom completions
_docker-clean() {
    _arguments \
        '--containers[Clean containers only]' \
        '--images[Clean images only]' \
        '--volumes[Clean volumes only]' \
        '--networks[Clean networks only]'
}
compdef _docker-clean docker-clean

# Kubernetes context completion
_k8s-ctx() {
    local contexts
    contexts=($(kubectl config get-contexts -o name 2>/dev/null))
    _describe 'contexts' contexts
}
compdef _k8s-ctx k8s-ctx

# Kubernetes namespace completion
_k8s-ns() {
    local namespaces
    namespaces=($(kubectl get namespaces -o name 2>/dev/null | cut -d/ -f2))
    _describe 'namespaces' namespaces
}
compdef _k8s-ns k8s-ns

# File search completions
_ff() {
    _arguments '1:filename pattern:'
}
compdef _ff ff

_fd() {
    _arguments '1:directory pattern:'
}
compdef _fd fd

# JSON completion for files
_json() {
    _arguments '1:json file:_files -g "*.json"'
}
compdef _json json

# Base64 functions completion
_b64encode() {
    _arguments '1:text to encode:'
}
compdef _b64encode b64encode

_b64decode() {
    _arguments '1:base64 text to decode:'
}
compdef _b64decode b64decode

# URL encode/decode completion
_urlencode() {
    _arguments '1:URL to encode:'
}
compdef _urlencode urlencode

_urldecode() {
    _arguments '1:URL to decode:'
}
compdef _urldecode urldecode

# Generate password completion
_genpass() {
    _arguments '1:length:(8 12 16 20 24 32)'
}
compdef _genpass genpass

# Performance monitoring completion
_topcpu() {
    _arguments '1:number of processes:(5 10 15 20)'
}
compdef _topcpu topcpu

_topmem() {
    _arguments '1:number of processes:(5 10 15 20)'
}
compdef _topmem topmem

# Case transformation completion
_upper() {
    _arguments '1:text to convert:'
}
compdef _upper upper

_lower() {
    _arguments '1:text to convert:'
}
compdef _lower lower

# Enhanced completion for common tools
if command -v gh >/dev/null; then
    eval "$(gh completion -s zsh)"
fi

if command -v terraform >/dev/null; then
    complete -o nospace -C terraform terraform
fi

if command -v vault >/dev/null; then
    complete -o nospace -C vault vault
fi

if command -v consul >/dev/null; then
    complete -o nospace -C consul consul
fi

# Completion for package managers
if command -v npm >/dev/null; then
    eval "$(npm completion 2>/dev/null)"
fi

if command -v yarn >/dev/null; then
    eval "$(yarn completions 2>/dev/null)"
fi

# macOS specific completions
if [[ "$OSTYPE" == darwin* ]]; then
    # Homebrew completion
    if command -v brew >/dev/null; then
        FPATH="${BREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions:${FPATH}"
    fi
    
    # macOS system commands
    compdef _precommand caffeinate
    compdef _precommand time
fi

# Load any additional completion scripts
if [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions" ]]; then
    fpath=("${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions" $fpath)
fi

# Rebuild completion cache if needed
if [[ ! -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache/.zcompdump" ]]; then
    mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
    compinit
fi
