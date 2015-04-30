#!/bin/bash -
pushd external/paper-gtk-theme
./install.sh
cd ../paper-icon-theme
./install-icon-theme.sh
popd
#gnome-shell --replace
