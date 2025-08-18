# vim: set ft=zsh:
# Zsh Aliases
# Modern aliases for improved productivity and safety

# Load shared aliases (common across all shells)
source "${ZDOTDIR:-$HOME/.config/zsh}/shared-aliases.zsh"

# Zsh-specific aliases and overrides
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Zsh global aliases (unique to zsh)
alias -g L='| less'
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g N='>/dev/null 2>&1'
alias -g J='| jq'
alias -g Y='| yq'
alias -g C='| wc -l'
alias -g S='| sort'
alias -g U='| uniq'

# Zsh suffix aliases (unique to zsh)
alias -s txt=nvim
alias -s md=nvim
alias -s json=nvim
alias -s yaml=nvim
alias -s yml=nvim
alias -s toml=nvim
alias -s sh=nvim
alias -s zsh=nvim
alias -s py=nvim
alias -s js=nvim
alias -s ts=nvim
alias -s html=nvim
alias -s css=nvim

# Archive suffix aliases
alias -s tar='tar -tf'
alias -s tar.gz='tar -tzf'
alias -s tar.bz2='tar -tjf'
alias -s zip='unzip -l'

# Extended git aliases (zsh-specific expansions)
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gds='git diff --staged'
alias gdt='git difftool'
alias gf='git fetch'
alias gfp='git fp'  # Use git alias for fetch-prune (from setup-git.sh)
alias gl='git l'    # Use git alias for formatted log (from setup-git.sh)
alias gll='git lg'  # Use git alias for graph log (from setup-git.sh)
alias gp='git push'
alias gpl='git pull'
alias gr='git remote'
alias grv='git remote -v'
alias gs='git s'    # Use git alias for short status (from setup-git.sh)
alias gss='git st'  # Use git alias for branch status (from setup-git.sh)
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'

# Additional git shortcuts leveraging git aliases from setup-git.sh
alias gmain='git main'      # Quick switch to main branch
alias gmaster='git master'  # Quick switch to master branch
alias gcleanup='git cleanup' # Clean merged branches
alias grecent='git recent'   # Show recent branches

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcl='docker-compose logs'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drmi='docker rmi'
alias drm='docker rm'
alias dex='docker exec -it'
alias dlogs='docker logs -f'

# Network and system
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias wget='wget -c'
alias curl='curl -L'
alias pubip='curl -s https://ipinfo.io/ip'
alias localip="ifconfig | grep -E 'inet [0-9]' | grep -v 127.0.0.1 | awk '{print \$2}'"

# File operations
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rg='rg --pretty'
alias find='find . -name'
alias du='du -h'
alias df='df -h'
alias free='free -h'
alias mount='mount | column -t'

# Process management
alias ps='ps aux'
alias psg='ps aux | grep'
alias top='top -o %CPU'
alias htop='htop -C'
alias jobs='jobs -l'

# Archive operations
alias targz='tar -czf'
alias untargz='tar -xzf'
alias tarbz='tar -cjf'
alias untarbz='tar -xjf'

# Text processing
alias h='head'
alias t='tail'
alias tf='tail -f'
alias less='less -R'
alias more='less'
alias cat='cat -n'  # Show line numbers
alias nl='nl -ba'   # Number all lines

# Development shortcuts
alias py='python3'
alias py2='python2'
alias ipy='ipython'
alias serve='python3 -m http.server'
alias jsonpp='python3 -m json.tool'

# Gradle
alias gw='./gradlew'

# Node.js / npm
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nu='npm update'
alias nls='npm list'
alias nout='npm outdated'

# Yarn
alias y='yarn'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn run'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias yu='yarn upgrade'

# System shortcuts
alias reload='source ${ZDOTDIR:-$HOME/.config/zsh}/.zshrc'
alias zshrc='${EDITOR:-vim} ${ZDOTDIR:-$HOME/.config/zsh}/.zshrc'
alias bashrc='${EDITOR:-vim} ~/.bashrc'
alias vimrc='${EDITOR:-vim} ~/.vimrc'
alias hosts='sudo ${EDITOR:-vim} /etc/hosts'

# macOS specific aliases
if [[ "$OSTYPE" == darwin* ]]; then
    alias finder='open -R'
    alias preview='open -a Preview'
    alias chrome='open -a "Google Chrome"'
    alias firefox='open -a Firefox'
    alias safari='open -a Safari'
    alias code='open -a "Visual Studio Code"'
    alias simulator='open -a Simulator'
    alias xcode='open -a Xcode'
    
    # System utilities
    alias flush='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
    alias lscleanup='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder'
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
    alias screensaver='open -a ScreenSaverEngine'
    alias afk='open -a ScreenSaverEngine'
    
    # Homebrew
    alias bu='brew update && brew upgrade'
    alias bc='brew cleanup'
    alias bd='brew doctor'
    alias bi='brew install'
    alias br='brew remove'
    alias bs='brew search'
    alias bl='brew list'
    alias bci='brew install --cask'
    alias bcl='brew list --cask'
    alias bcs='brew search --cask'
fi

# Linux specific aliases
if [[ "$OSTYPE" == linux* ]]; then
    alias open='xdg-open'
    
    # Package management (detect system)
    if command -v apt >/dev/null; then
        alias install='sudo apt install'
        alias update='sudo apt update && sudo apt upgrade'
        alias search='apt search'
        alias remove='sudo apt remove'
        alias autoremove='sudo apt autoremove'
    elif command -v yum >/dev/null; then
        alias install='sudo yum install'
        alias update='sudo yum update'
        alias search='yum search'
        alias remove='sudo yum remove'
    elif command -v pacman >/dev/null; then
        alias install='sudo pacman -S'
        alias update='sudo pacman -Syu'
        alias search='pacman -Ss'
        alias remove='sudo pacman -Rs'
    fi
    
    # System info
    alias sysinfo='inxi -Fxz'
    alias diskusage='df -h | grep -E "^(/dev/)"'
    alias meminfo='free -h'
    alias cpuinfo='lscpu'
fi

# Editor shortcuts
alias v='${EDITOR:-vim}'
alias vi='${EDITOR:-vim}'
alias vim='${EDITOR:-vim}'
alias nano='nano -w'
alias emacs='emacs -nw'

# Quick edits
alias zshconfig='${EDITOR:-vim} ${ZDOTDIR:-$HOME/.config/zsh}/.zshrc'
alias ohmyzsh='${EDITOR:-vim} ~/.oh-my-zsh'
alias aliases='${EDITOR:-vim} ${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh'
alias functions='${EDITOR:-vim} ${ZDOTDIR:-$HOME/.config/zsh}/functions.zsh'

# Safety aliases (macOS compatible)
alias chown='chown -R'
alias chgrp='chgrp -R'

# Time and date
alias now='date +"%T"'
alias nowtime='date'
alias nowdate='date +"%d-%m-%Y"'
alias week='date +%V'

# Fun and useful
alias weather='curl wttr.in'
alias moon='curl wttr.in/moon'
alias news='curl getnews.tech'
alias cheat='curl cht.sh'
alias qr='curl qrenco.de'

# Miscellaneous
alias c='clear'
alias cls='clear'
alias x='exit'
alias q='exit'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LS_LIBRARY_PATH//:/\\n}'
alias src='source'
alias which='command which'
alias j='jobs -l'
alias h='history'
alias hgrep='history | grep'

# Quick navigation to common directories
alias dl='cd ~/Downloads'
alias doc='cd ~/Documents'
alias dt='cd ~/Desktop'
alias proj='cd ~/Projects'
alias dots='cd ~/.dotfiles'

# Quick access to configuration files
alias zshrc='${EDITOR:-vim} ${ZDOTDIR:-$HOME/.config/zsh}/.zshrc'
alias zprofile='${EDITOR:-vim} ${ZDOTDIR:-$HOME/.config/zsh}/.zprofile'
alias zshenv='${EDITOR:-vim} ~/.zshenv'
alias gitconfig='${EDITOR:-vim} ~/.gitconfig'
alias sshconfig='${EDITOR:-vim} ~/.ssh/config'
alias vimrc='${EDITOR:-vim} ~/.vimrc'
alias tmuxconf='${EDITOR:-vim} ~/.tmux.conf'

# Modern alternatives (install with package manager)
if command -v eza >/dev/null; then
    alias ls='eza --color=auto'
    alias ll='eza -l --git'
    alias la='eza -la --git'
    alias l='eza --color=auto'
    alias lh='eza -lah --git'
    alias lt='eza -la --sort=modified --git'
    alias tree='eza --tree'
fi

command -v bat >/dev/null && alias cat='bat --paging=never'
command -v fd >/dev/null && alias find='fd'
command -v rg >/dev/null && alias grep='rg'
command -v htop >/dev/null && alias top='htop'
command -v prettyping >/dev/null && alias ping='prettyping --nolegend'
command -v ncdu >/dev/null && alias du='ncdu --color dark -rr -x --exclude .git --exclude node_modules'

# Additional global aliases (zsh specific)
alias -g CA="2>&1 | cat -A"
alias -g C='| wc -l'
alias -g D="DISPLAY=:0.0"
alias -g DN=/dev/null
alias -g ED="export DISPLAY=:0.0"
alias -g EG='|& egrep'
alias -g EH='|& head'
alias -g EL='|& less'
alias -g ELS='|& less -S'
alias -g ET='|& tail'
alias -g F=' | fmt -'
alias -g G='| grep'
alias -g H='| head'
alias -g HL='|& head -20'
alias -g Sk="*~(*.bz2|*.gz|*.tgz|*.zip|*.z)"
alias -g LL="2>&1 | less"
alias -g L="| less"
alias -g LS='| less -S'
alias -g MM='| most'
alias -g M='| more'
alias -g NE="2> /dev/null"
alias -g NS='| sort -n'
alias -g NUL="> /dev/null 2>&1"
alias -g PIPE='|'
alias -g R=' > /c/aaa/tee.txt '
alias -g RNS='| sort -nr'
alias -g S='| sort'
alias -g TL='| tail -20'
alias -g T='| tail'
alias -g US='| sort -u'
alias -g VM=/var/log/messages
alias -g X0G='| xargs -0 egrep'
alias -g X0='| xargs -0'
alias -g XG='| xargs egrep'
alias -g X='| xargs'
