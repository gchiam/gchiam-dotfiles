#!/bin/bash

pushd ~/.vim
mkdir -p bundle && cd bundle
git clone https://github.com/kien/ctrlp.vim.git bundle/ctrlp.vim
popd

