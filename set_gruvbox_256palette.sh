#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  source $DOTFILES_DIR/.vim/plugged/gruvbox/gruvbox_256palette_osx.sh
else
  source $DOTFILES_DIR/.vim/plugged/gruvbox/gruvbox_256palette.sh
fi
