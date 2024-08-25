export PKG_CONFIG_PATH=/usr/share/pkgconfig:$PKG_CONFIG_PATH

[ -f /etc/bashrc ] && source /etc/bashrc

[ -n "$PS1" ] && source ~/.bash_profile

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(starship init bash)"
