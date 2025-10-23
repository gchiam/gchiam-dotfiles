# shellcheck shell=bash
export PKG_CONFIG_PATH=/usr/share/pkgconfig:$PKG_CONFIG_PATH

# shellcheck source=/dev/null
[ -f /etc/bashrc ] && source /etc/bashrc

# shellcheck source=/dev/null
[ -n "$PS1" ] && source ~/.bash_profile

# shellcheck source=/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(starship init bash)"
