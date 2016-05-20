mkvirtualenv -p `which python2` neovim-py2; workon neovim-py2
pip install -U pip
pip install -U -r pip-requirements/neovim.txt
deactivate

mkvirtualenv -p `which python3` neovim-py3; workon neovim-py3
pip install -U pip
pip install -U -r pip-requirements/neovim.txt
deactivate
