HISTSIZE=10000
SAVEHIST=10000
setopt share_history

export PATH="${PATH}:${HOME}/.local/bin"

# User configuration
export PATH=$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH
source $HOME/.bash_path
source $HOME/.bash_exports
source $HOME/.bash_aliases
test -e $HOME/.bash_local && source $HOME/.bash_local

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/gchiam/.sdkman"
[[ -s "/Users/gchiam/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/gchiam/.sdkman/bin/sdkman-init.sh"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# eval "$(starship init zsh)"

# PATH="/Users/gchiam/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="/Users/gchiam/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="/Users/gchiam/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"/Users/gchiam/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/Users/gchiam/perl5"; export PERL_MM_OPT;

# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# eval "$(pyenv init - zsh)"
# eval "$(pyenv virtualenv-init -)"
# eval "$(rbenv init - zsh)"
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"

zvm_config() {
  ZVM_INIT_MODE=sourcing
  ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
  ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
  # Always starting with insert mode for each command line
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

function zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load $HOME/.config/antidote/.zsh_plugins.txt

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/oh-my-posh.toml)"
