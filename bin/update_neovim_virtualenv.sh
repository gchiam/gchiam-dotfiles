workon neovim-py2
pip install -U pip
pip install -U -r pip-requirements/neovim.txt
deactivate

workon neovim-py3
pip install -U pip
pip install -U -r pip-requirements/neovim.txt
deactivate
