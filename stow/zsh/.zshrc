HISTSIZE=10000
SAVEHIST=10000
setopt share_history

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

export PATH="${PATH}:${HOME}/.local/bin"

source $HOME/.bash_path
export PATH=$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH
source $HOME/.bash_path
source $HOME/.bash_exports
source $HOME/.bash_aliases
test -e $HOME/.bash_local && source $HOME/.bash_local

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


[ -d $HOME/.jenv ] && export PATH="$HOME/.jenv/bin:$PATH"
[ $commands[jenv] ] && eval "$(jenv init -)"

zvm_config() {
  # jeffreytse/zsh-vi-mode
  ZVM_INIT_MODE=sourcing
  ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
  ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
  # Always starting with insert mode for each command line
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

  # zsh-users/zsh-history-substring-search
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=black,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=black,bold'
}

function zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  bindkey '^[OA' history-substring-search-up   # Up
  bindkey '^[[A' history-substring-search-up   # Up

  bindkey '^[OB' history-substring-search-down # Down
  bindkey '^[[B' history-substring-search-down # Down

  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
}

if [ $commands[brew] ]
then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

source $(brew --prefix antidote)/share/antidote/antidote.zsh
antidote load $HOME/.config/antidote/.zsh_plugins.txt

[ $commands[cicd] ] && source <(cicd completion zsh); compdef _cicd cicd
[ $commands[zetup] ] && source <(zetup completion zsh)

zstyle ':plugin:ez-compinit' 'compstyle' 'zshzoo'
zstyle ':completion:*' use-cache on

source $(antidote path gradle/gradle-completion)/_gradle 1>&2 2>/dev/null

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/oh-my-posh.toml)"
