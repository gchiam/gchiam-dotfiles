#!/bin/sh

rm -f .vim/plugged/vim-expand-region/doc/tags
rm -f .vim/plugged/xterm-color-table.vim/doc/tags

git add .vim/plugged
git commit -m "vim: Update vim-plugged modules"
