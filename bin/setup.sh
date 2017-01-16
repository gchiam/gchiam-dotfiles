#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

ln -snvf $HOME/projects/gchiam-dotfiles $DOTFILES_DIR

ln -snvf $DOTFILES_DIR/.bashrc $HOME/
ln -snvf $DOTFILES_DIR/.bash_profile $HOME/
ln -snvf $DOTFILES_DIR/.bash_prompt $HOME/
ln -snvf $DOTFILES_DIR/.bash_aliases $HOME/
ln -snvf $DOTFILES_DIR/.bash_completion $HOME/
ln -snvf $DOTFILES_DIR/.bash_exports $HOME/
ln -snvf $DOTFILES_DIR/.bash_extra $HOME/
ln -snvf $DOTFILES_DIR/.bash_motd $HOME/
ln -snvf $DOTFILES_DIR/.bash_private $HOME/
ln -snvf $DOTFILES_DIR/.bash_virtualenvwrapper $HOME/
ln -snvf $DOTFILES_DIR/.inputrc $HOME/
ln -snvf $DOTFILES_DIR/.grepg.yml $HOME/
ln -snvf $DOTFILES_DIR/.zshrc $HOME/
ln -snvf $DOTFILES_DIR/.pylintrc $HOME/
ln -snvf $DOTFILES_DIR/.oh-my-fish $HOME/
ln -snvf $DOTFILES_DIR/.oh-my-zsh $HOME/
ln -snvf $DOTFILES_DIR/.django_bash_completion $HOME/
ln -snvf $DOTFILES_DIR/.tigrc $HOME/
ln -snvf $DOTFILES_DIR/.tmux $HOME/
ln -snvf $DOTFILES_DIR/.tmux*.conf $HOME/
ln -snvf $DOTFILES_DIR/.vim $HOME/
ln -snvf $DOTFILES_DIR/.vimrc $HOME/
ln -snvf $DOTFILES_DIR/.vimrc.d $HOME/
ln -snvf $DOTFILES_DIR/.nvim $HOME/
ln -snvf $DOTFILES_DIR/.nvimrc $HOME/
ln -snvf $DOTFILES_DIR/.ptpython $HOME/
ln -snvf $DOTFILES_DIR/.fonts.conf $HOME/
ln -snvf $DOTFILES_DIR/.Xresources $HOME/
ln -snvf $DOTFILES_DIR/.promptline.sh $HOME/
ln -snvf $DOTFILES_DIR/.zazurc.json $HOME/
ln -snvf $DOTFILES_DIR/external/base16-shell/colortest $HOME/bin/

mkdir -p $HOME/bin
for f in `find $DOTFILES_DIR/bin/deploy -mindepth 1 -maxdepth 1`
do
    ln -snvf $f $HOME/bin/
done

test -d $HOME/.themes || mkdir -p $HOME/.themes
for f in `find $DOTFILES_DIR/.themes -mindepth 1 -maxdepth 1`
do
    ln -snvf $f $HOME/.themes/
done

test -d $HOME/.config || mkdir -p $HOME/.config
for f in `find $DOTFILES_DIR/.config -mindepth 1 -maxdepth 1`
do
    ln -snvf $f $HOME/.config/
done


# git bash completion
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash
