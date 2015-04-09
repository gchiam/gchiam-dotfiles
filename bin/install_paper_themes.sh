#!/bin/bash -
pushd external/paper-gtk-theme
./install.sh
cd ../paper-icon-theme
./install.sh
popd
#gnome-shell --replace
