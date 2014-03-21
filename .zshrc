# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# The following lines were added by compinstall
zstyle :compinstall filename '/home/gordon.chiam/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
# End of lines configured by zsh-newuser-install
#
#

plugins=(vi-mode git)

source $ZSH/oh-my-zsh.sh

source $HOME/.bash_exports
source $HOME/.bash_aliases
setopt nocorrectall

. ~/.powerline.zsh

test -d $HOME/.rvm/bin && (which rvm > /dev/null 2>&1) || PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
