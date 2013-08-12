#!/bin/bash

pushd ~/.vim
mkdir -p bundle && cd bundle
git clone https://github.com/pangloss/vim-javascript.git
popd

