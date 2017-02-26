#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  source $DOTFILES_DIR/.vim/repos/github.com/morhetz/gruvbox/gruvbox_256palette_osx.sh
else
  source $DOTFILES_DIR/.vim/repos/github.com/morhetz/gruvbox/gruvbox_256palette.sh
fi
