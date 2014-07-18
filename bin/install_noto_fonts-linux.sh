#!/bin/bash - 
#===============================================================================
#
#          FILE: install_noto_fonts-linux.sh
# 
#         USAGE: ./install_noto_fonts-linux.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 07/18/2014 10:04
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

fonts_zip_file="Noto-hinted.zip"
fonts_url="http://www.google.com/get/noto/pkgs/${fonts_zip_file}"
fonts_dir="${HOME}/.fonts"

echo "Downloading fonts..."
wget http://www.google.com/get/noto/pkgs/Noto-hinted.zip

echo "Copying font files..."
mkdir noto_temp
cd noto_temp
unzip -q ../Noto-hinted.zip
mkdir -p ${fonts_dir}/Noto
cp *.ttf ${font_dir}/Noto
cd ..

echo "Cleaning..."
rm Noto-hinted.zip
rm -rf noto_temp
echo "Done"
