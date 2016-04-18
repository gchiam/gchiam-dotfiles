#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  source .vim/plugged/gruvbox/gruvbox_256palette_osx.sh
else
  source .vim/plugged/gruvbox/gruvbox_256palette.sh
fi
