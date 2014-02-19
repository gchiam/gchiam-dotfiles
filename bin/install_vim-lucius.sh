#!/bin/bash

pushd ~/.vim
mkdir -p bundle && cd bundle
git clone git://github.com/jonathanfilip/vim-lucius.git
popd

