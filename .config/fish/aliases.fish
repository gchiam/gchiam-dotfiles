# ============================================================================
# Copied from
# https://github.com/mbrochh/mbrochh-dotfiles/blob/master/.bash_aliases
# ============================================================================

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."


# Personal shortcuts
alias e="cd ~/Envs"
alias d="cd ~/projects/gchiam-dotfiles"
alias p="cd ~/projects"
alias c="clear"
alias sbrc="source ~/.bashrc"
alias v="nvim"

# Git related shortcuts
alias g="git"
alias ga="git add ."
alias gd="git diff"
alias gdt="git difftool"
alias gst="git status"
alias gps="git push"
alias gpl="git pull"
alias gc="git commit"
alias gl="git log"
alias glg="git lg"
alias gm="git checkout master"

# python related shortcuts
alias rmpyc="find . -name \*.pyc -exec rm {} \;"

# Django related shortcuts
alias mprs="./manage.py runserver"
alias mpm="./manage.py migrate"

# Misc tools
alias cdiff="cdiff --side-by-side"


# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"
