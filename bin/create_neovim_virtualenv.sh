# vim: set filetype=sh:


. ~/.bash_virtualenvwrapper

make_venv() {
    PYTHON="$1"
    venv_name="$2"
    venv_dir="${WORKON_HOME}/${venv_name}"

    test -e ${venv_dir} && rm -rf ${venv_dir}

    mkvirtualenv -p $PYTHON ${venv_name}
    PIP="${venv_dir}/bin/pip"
    $PIP install -U pip
    $PIP install -U -r pip-requirements/neovim.txt
}

make_venv `which python2` neovim-py2
make_venv `which python3` neovim-py3
