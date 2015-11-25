#!/bin/bash - 
#===============================================================================
#
#          FILE: pull_submodules.sh
# 
#         USAGE: ./pull_submodules.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Gordon Chiam NAME (gordon.chiam@gmail.com), 
#  ORGANIZATION: 
#       CREATED: 04/11/2014 14:29
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

rm -f external/bash-support.vim/doc/tags*
rm -f external/xterm-color-table.vim/doc/tags
rm -f external/vim-multiple-cursors/doc/tags
rm -f external/vim-startify/doc/tags
rm -f external/vim-expand-region/doc/tags

git submodule foreach git pull origin master
