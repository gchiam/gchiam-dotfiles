#!/bin/bash

if [ -d $HOME/projects/vim ]
then
    cd $HOME/projects/vim
    hg pull
    cd vim/src
    ./configure --enable-pythoninterp --with-features=huge --prefix=$HOME/opt/vim
    make && make install
    mkdir -p $HOME/bin/
    cd $HOME/bin/
    #ln -s $HOME/opt/vim/bin/vim
    which vim
    vim --version
fi
