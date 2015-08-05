#!/bin/bash

if [ -d $HOME/projects/neovim ]
then
    cd $HOME/projects/neovim
    git pull
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$HOME/opt/neovim" install
    mkdir -p $HOME/bin/
    ln -snvf $HOME/opt/neovim/bin/nvim $HOME/bin/
    which nvim
    nvim --version
fi
