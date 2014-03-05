#!/bin/bash

fonts_dir="${HOME}/.fonts"
base_dir="${HOME}/projects/gchiam-dotfiles"
powerline_fonts_dir="${base_dir}/external/powerline-fonts/"

mkdir -p ${fonts_dir}

for f in `ls  -1 ${powerline_fonts_dir}`
do
    test -d $f && ln -snvf ${powerline_fonts_dir}/$f ${fonts_dir}/$f
done
