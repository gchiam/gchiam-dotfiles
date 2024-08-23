#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

ln -snvf $HOME/projects/gchiam-dotfiles $DOTFILES_DIR

ln -snvf $DOTFILES_DIR/.bashrc $HOME/
ln -snvf $DOTFILES_DIR/.bash_profile $HOME/
ln -snvf $DOTFILES_DIR/.bash_path $HOME/
ln -snvf $DOTFILES_DIR/.bash_prompt $HOME/
ln -snvf $DOTFILES_DIR/.bash_aliases $HOME/
ln -snvf $DOTFILES_DIR/.bash_completion $HOME/
ln -snvf $DOTFILES_DIR/.bash_exports $HOME/
ln -snvf $DOTFILES_DIR/.bash_extra $HOME/
ln -snvf $DOTFILES_DIR/.bash_motd $HOME/
ln -snvf $DOTFILES_DIR/.Brewfile $HOME/
ln -snvf $DOTFILES_DIR/.inputrc $HOME/
ln -snvf $DOTFILES_DIR/.grepg.yml $HOME/
ln -snvf $DOTFILES_DIR/.zshrc $HOME/
ln -snvf $DOTFILES_DIR/.pylintrc $HOME/
ln -snvf $DOTFILES_DIR/.ohmyzsh $HOME/
ln -snvf $DOTFILES_DIR/.starship.toml $HOME/
ln -snvf $DOTFILES_DIR/.tigrc $HOME/
ln -snvf $DOTFILES_DIR/.tmux $HOME/
ln -snvf $DOTFILES_DIR/.tmux*.conf $HOME/
ln -snvf $DOTFILES_DIR/.ptpython $HOME/
ln -snvf $DOTFILES_DIR/.fonts.conf $HOME/
ln -snvf $DOTFILES_DIR/.Xresources $HOME/

mkdir -p $HOME/bin
for f in $(find $DOTFILES_DIR/bin/deploy -mindepth 1 -maxdepth 1); do
	ln -snvf $f $HOME/bin/
done

test -d $HOME/.config || mkdir -p $HOME/.config
for f in $(find $DOTFILES_DIR/.config -mindepth 1 -maxdepth 1); do
	ln -snvf $f $HOME/.config/
done

# generate ~/fleet.properties
echo "fleet.config.path=${HOME}/.config/JetBrains/Fleet/" > ~/fleet.properties
