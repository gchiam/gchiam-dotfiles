# vim: set filetype=sh:


. ~/.bash_virtualenvwrapper

make_venv() {
    venv_name="$1"
    venv_dir="${WORKON_HOME}/${venv_name}"

    test -e ${venv_dir} && rm -rf ${venv_dir}

    mkvirtualenv -p `which python2` ${venv_name}
    PIP="${venv_dir}/bin/pip"
    $PIP install -U pip
    $PIP install -U -r pip-requirements/neovim.txt
}

make_venv neovim-py2
make_venv neovim-py3
