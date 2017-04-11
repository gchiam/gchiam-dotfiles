#!/bin/bash -
#===============================================================================
#
#          FILE: simplehttpserver.sh
#
#         USAGE: ./simplehttpserver.sh
#
#   DESCRIPTION: start the Python simple Http server
#
#       OPTIONS: None
#  REQUIREMENTS: None
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Gordon Chiam (gordon.chiam@gmail.com)
#  ORGANIZATION: 
#       CREATED: 07/28/2014 14:19
#      REVISION: ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

python -m SimpleHTTPServer $@
