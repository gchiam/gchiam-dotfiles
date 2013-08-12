#!/bin/bash

pushd ~/.vim
mkdir -p bundle && cd bundle
git clone git://github.com/briancollins/vim-jst.git
popd

