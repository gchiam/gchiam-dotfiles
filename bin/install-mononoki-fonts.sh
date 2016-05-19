#!/bin/bash

# Set source and target directories
url="https://raw.githubusercontent.com/madmalik/mononoki/master/export/mononoki.zip"
tmp_dir="/tmp/mononoki"

mkdir -p ${tmp_dir}
pushd ${tmp_dir}
echo "-o mononoki.zip ${url}"
wget -O mononoki.zip ${url}
unzip mononoki.zip
popd

if [[ `uname` == 'Darwin' ]]; then
  # MacOS
  font_dir="$HOME/Library/Fonts"
else
  # Linux
  font_dir="$HOME/.fonts"
fi
font_dir="${font_dir}/mononoki"
mkdir -p ${font_dir}

# Copy all fonts to user fonts directory
cp ${tmp_dir}/*.ttf ${font_dir}
rm -rf ${tmp_dir}

# Reset font cache on Linux
if [[ -n `which fc-cache` ]]; then
  fc-cache -f ${font_dir}
fi

echo "All Mononoki fonts installed to ${font_dir}"
