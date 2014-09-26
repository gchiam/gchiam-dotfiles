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

git submodule foreach git pull origin master

rm external/bash-support.vim/doc/tags*
rm external/xterm-color-table.vim/doc/tags 
