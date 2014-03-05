#!/bin/bash

pushd external/powerline-shell/
python install.py
sed -i "s/THEME = '.*'/THEME = 'solarized-dark'/" config.py
python install.py
popd
ln -snvf external/powerline-shell/powerline-shell.py powerline-shell.py
