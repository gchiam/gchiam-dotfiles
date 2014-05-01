#!/bin/bash - 
#===============================================================================
#
#          FILE: create_ramdisk.sh
# 
#         USAGE: ./create_ramdisk.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/28/2014 12:11
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

sudo mount -t tmpfs -o size=512m tmpfs /mnt/ramdisk

