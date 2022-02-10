
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####
export PKG_CONFIG_PATH=/usr/share/pkgconfig:$PKG_CONFIG_PATH

[ -f /etc/bashrc ] && source /etc/bashrc

[ -n "$PS1" ] && source ~/.bash_profile

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(starship init bash)"

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
