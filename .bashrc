# Fig pre block. Keep at the top of this file.
export PATH="${PATH}:${HOME}/.local/bin"
eval "$(fig init bash pre)"

export PKG_CONFIG_PATH=/usr/share/pkgconfig:$PKG_CONFIG_PATH

[ -f /etc/bashrc ] && source /etc/bashrc

[ -n "$PS1" ] && source ~/.bash_profile

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(starship init bash)"

# Fig post block. Keep at the bottom of this file.
eval "$(fig init bash post)"

