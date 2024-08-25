# fzf
# https://github.com/junegunn/fzf
# Setting ag as the default source for fzf
set -x FZF_DEFAULT_COMMAND 'ag -g ""'

# To apply the command to CTRL-T as well
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

set -x FZF_DEFAULT_OPTS "--color=dark,fg:245,hl:15,fg+:16,bg+:2"
