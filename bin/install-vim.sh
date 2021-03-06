#!/bin/bash

test -d $HOME/projects || mkdir $HOME/projects
cd $HOME/projects
hg clone https://vim.googlecode.com/hg/ vim
cd vim/src
./configure --enable-pythoninterp --with-features=huge --prefix=$HOME/opt/vim
make && make install
mkdir -p $HOME/bin/
ln -snvf $HOME/opt/vim/bin/vim $HOME/bin/
which vim
vim --version

echo "On Ubuntu:"
echo "sudo apt-get install gtk2-engines-pixbuf"

