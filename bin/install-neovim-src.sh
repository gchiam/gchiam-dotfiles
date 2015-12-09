#!/bin/bash

test -d $HOME/projects || mkdir $HOME/projects
cd $HOME/projects
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$HOME/opt/neovim" install
mkdir -p $HOME/bin/
ln -snvf $HOME/opt/neovim/bin/nvim $HOME/bin/
which nvim
nvim --version

echo "pip install neovim"
