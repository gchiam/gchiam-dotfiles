export PATH="${PATH}:${HOME}/.local/bin"

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# User configuration
export PATH=$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH
source $HOME/.bash_path

source $HOME/.bash_exports
source $HOME/.bash_aliases
test -e $HOME/.bash_local && source $HOME/.bash_local

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# bind v to edit command line
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi
export CLOUDSDK_PYTHON=python3


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/gchiam/.sdkman"
[[ -s "/Users/gchiam/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/gchiam/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# PATH="/Users/gchiam/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="/Users/gchiam/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="/Users/gchiam/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"/Users/gchiam/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/Users/gchiam/perl5"; export PERL_MM_OPT;

# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# eval "$(pyenv init - zsh)"
# eval "$(pyenv virtualenv-init -)"
# eval "$(rbenv init - zsh)"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/oh-my-posh.toml)"

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load $HOME/.config/antidote/.zsh_plugins.txt

function zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}
