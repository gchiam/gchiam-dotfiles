#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
ln -snvf $HOME/projects/gchiam-dotfiles $DOTFILES_DIR

# Run stow
stow_dir=${DOTFILES_DIR}/stow
if ! command -v stow &> /dev/null
then
    echo "stow could not be found. Will not brew install stow."
    brew install stow
fi

for d in $(ls -1 ${stow_dir}); do
  echo "stowing $d..."
  stow --dir=${stow_dir} --target=$HOME --restow $d
done

ln -snvf $DOTFILES_DIR/.Xresources $HOME/

mkdir -p $HOME/bin
for f in $(find $DOTFILES_DIR/bin/deploy -mindepth 1 -maxdepth 1); do
	ln -snvf $f $HOME/bin/
done

# generate ~/fleet.properties
echo "fleet.config.path=${HOME}/.config/JetBrains/Fleet/" > ~/fleet.properties
