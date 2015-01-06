#!/bin/bash - 
#===============================================================================
#
#          FILE: fix-yosemite-wifi.sh
# 
#         USAGE: ./fix-yosemite-wifi.sh 
# 
#   DESCRIPTION:
#   http://lifehacker.com/fix-yosemite-wi-fi-issues-with-a-terminal-command-1663414063
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 12/01/14 21:19
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

sudo ifconfig awdl0 down
