#!/bin/bash - 
set -o nounset                              # Treat unset variables as an error

fonts_zip_file="Noto-hinted.zip"
fonts_url="https://noto-website-2.storage.googleapis.com/pkgs/${fonts_zip_file}"

if [[ `uname` == 'Darwin' ]]; then
  # MacOS
  font_dir="$HOME/Library/Fonts"
else
  # Linux
  font_dir="$HOME/.fonts"
  mkdir -p $font_dir
fi

echo "Downloading fonts..."
wget "${fonts_url}"

echo "Copying font files..."
mkdir -p noto_temp
cd noto_temp
unzip -q ../${fonts_zip_file}
mkdir -p ${font_dir}/Noto
cp *.ttf ${font_dir}/Noto
cd ..

echo "Cleaning..."
rm ${fonts_zip_file}
rm -rf noto_temp

echo "All Noto fonts installed to $font_dir"
echo "Done"
