#!/bin/bash

pushd ~/.vim
mkdir -p bundle && cd bundle
git clone https://github.com/christoomey/vim-tmux-navigator.git
popd

