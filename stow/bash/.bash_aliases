# vim: set filetype=sh:

# ============================================================================
# Copied from
# https://github.com/mbrochh/mbrochh-dotfiles/blob/master/.bash_aliases
# ============================================================================

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."


# Easier file & directory listing
if (which eza > /dev/null);  then
    alias ls='eza'  # directories and files in columns
    alias la='eza -la --icons=always'  # directories and files incl. hidden in columns
    alias ll='eza -ahlF --icons=always --group-directories-first'  # everything with extra info as a list
else
    alias l='ls -CF'  # directories and files in columns
    alias la='ls -A'  # directories and files incl. hidden in columns
    alias ll='ls -ahlF'  # everything with extra info as a list
fi

alias isdark="defaults read -globalDomain AppleInterfaceStyle &> /dev/null"
alias bat="bat --theme=\"\$(ifdark 'Catppuccin Frappe' 'Catppuccin Latte')\""
alias cat="bat --style=plain"

# Personal shortcuts
alias d="cd ~/projects/gchiam-dotfiles"
alias p="cd ~/projects"
alias c="clear"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

#https://www.reddit.com/r/neovim/comments/3hz2zv/how_to_accomodate_a_mental_failing_alias_envim/
alias :e='nvim'
alias :E='nvim .'
alias :q='exit'

# Gradle
alias gd="./gradlew"

# Git related shortcuts
alias g="git"
alias ga="git add ."
alias gdt="git difftool"
alias gst="git status"
alias gps="git push"
alias gpl="git pull"
alias gc="git commit"
alias gl="git log"
alias glg="git lg"
alias gm="git checkout master"

alias testgithub="ssh -T git@github.com"

# ag related shortcuts
alias agpy="ag --python"
alias agjs="ag --js"
alias aghtml="ag --html"

# Always use color output for `ls`
if [[ "$OSTYPE" =~ ^darwin ]]; then
    alias ls="command ls -G"
elif [ -f $HOME/.dircolors ]; then
    alias ls="command ls --color"
    eval `dircolors ~/.dircolors`
else
    alias ls="command ls --color"
    export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias jqenv="jq -n -S '\$ENV | map_values(if test(\":\",.) and (test(\"(tcp|http[s]?)://\",.) | not) then split(\":\") else . end)'"

alias stow='stow -v --dir="$DOTFILES_DIR/stow" --target=$HOME --restow'
