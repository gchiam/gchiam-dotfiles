#!/bin/bash

PY2_VERSION="2.7.16"
PY3_VERSION="3.7.4"

pyenv install $PY2_VERSION
pyenv install $PY3_VERSION

pyenv virtualenv $PY2_VERSION neovim-py2 "${WORKON_HOME}/neovim-py2"
pyenv virtualenv $PY3_VERSION neovim-py3 "${WORKON_HOME}/neovim-py3"

pyenv activate neovim-py2
pip install -U -r pip-requirements/neovim.txt
pyenv which python

pyenv activate neovim-py3
pip install -U -r pip-requirements/neovim.txt
pyenv which python
