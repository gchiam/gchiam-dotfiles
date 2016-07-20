# vim: set filetype=sh:


. ~/.bash_virtualenvwrapper

update_env() {
    venv_name="$1"
    venv_dir="${WORKON_HOME}/${venv_name}"

    PIP="${venv_dir}/bin/pip"
    $PIP install -U pip
    $PIP install -U -r pip-requirements/neovim.txt
}

update_env neovim-py2
update_env neovim-py3
