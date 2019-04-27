#!/bin/bash

ZSH_CUSTOM=${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}
ln -snvf $DOTFILES_DIR/external/spaceship-prompt $ZSH_CUSTOM/themes/
ln -snvf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
