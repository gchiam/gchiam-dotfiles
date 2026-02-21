# vim: set ft=zsh:
# shellcheck shell=bash disable=SC2148,SC1090,SC1091,SC2142,SC2034,SC2154,SC1087,SC2206,SC2296,SC2207,SC2155,SC2086,SC2126,SC2245,SC1036,SC1088
# Shared Aliases Configuration
# Common aliases used across bash, zsh, and fish shells
# This reduces duplication and ensures consistency

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# Directory shortcuts
alias d="cd ~/projects/gchiam-dotfiles"
alias p="cd ~/projects"
alias c="clear"

# Editor shortcuts
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias e="nvim"

# Vim-like shortcuts for the terminal
alias :e='nvim'
alias :E='nvim .'
alias :q='exit'

# Git shortcuts (lightweight ones)
alias g="git"
alias ga="git add"
alias gd="git diff"
alias gdt="git difftool"
alias gs="git status"
alias gl="git log --oneline -10"

# Directory listing (modern alternatives with fallbacks)
if command -v eza >/dev/null; then
    alias ls='eza --icons=auto'
    alias ll='eza -la --icons=always --group-directories-first'
    alias la='eza -a --icons=always'
    alias lt='eza -la --sort=modified --icons=always'
    alias tree='eza --tree --icons=always'
else
    # Fallback to traditional ls with color support
    if [[ "$OSTYPE" == darwin* ]]; then
        alias ls='ls -G'
    else
        alias ls='ls --color=auto'
    fi
    alias ll='ls -alF'
    alias la='ls -A'
    alias lt='ls -lart'
fi

# Enhanced cat with bat (if available)
if command -v bat >/dev/null; then
    # Dynamic theme based on macOS dark mode
    if [[ "$OSTYPE" == darwin* ]]; then
        alias bat="bat --theme=\"\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo 'Catppuccin Frappe' || echo 'Catppuccin Latte')\""
    else
        alias bat="bat --theme='Catppuccin Frappe'"
    fi
    alias cat="bat --style=plain"
fi

# Safe operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Directory operations
alias md='mkdir -p'
alias rd='rmdir'

# System information shortcuts
alias df='df -h'
alias du='du -h'
alias free='free -h 2>/dev/null || echo "free command not available on macOS"'

# Network shortcuts
alias ping='ping -c 5'
alias ports='netstat -tuln'

# Process shortcuts
alias psg='ps aux | grep'
alias h='history'
alias hg='history | grep'

# macOS specific shortcuts
if [[ "$OSTYPE" == darwin* ]]; then
    alias isdark="defaults read -globalDomain AppleInterfaceStyle &> /dev/null"
    alias finder='open -a Finder'
    alias preview='open -a Preview'
    alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
fi

# Docker shortcuts (lightweight ones)
if command -v docker >/dev/null; then
    alias dk='docker'
    alias dkps='docker ps'
    alias dkpa='docker ps -a'
    alias dki='docker images'
fi

# Kubernetes shortcuts (lightweight ones)
if command -v kubectl >/dev/null; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get services'
    alias kgd='kubectl get deployments'
fi

# Development shortcuts
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias today='date +"%d-%m-%Y"'

# Text processing shortcuts
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Archive shortcuts
alias targz='tar -czf'
alias untar='tar -xzf'

# URL shortcuts
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'

# Export shared aliases flag
export SHARED_ALIASES_LOADED=true
