export PATH="${PATH}:${HOME}/.local/bin"

# Path to your ohmyzsh installation.
export ZSH=$HOME/.ohmyzsh

# Set name of the theme to load.
# Look in ~/.ohmyzsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that ohmyzsh is loaded.
# ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"
# ZSH_THEME="ys"
# ZSH_THEME="refined"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# User configuration
export PATH=$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/opt/mysql-client@5.7/bin:$PATH"
source $HOME/.bash_path

# Which plugins would you like to load? (plugins can be found in ~/.ohmyzsh/plugins/*)
# Custom plugins may be added to ~/.ohmyzsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fzf git python tmux vi-mode z)

source $ZSH/oh-my-zsh.sh
source $HOME/.bash_exports
source $HOME/.bash_aliases
test -e $HOME/.bash_local && source $HOME/.bash_local

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by ohmyzsh libs,
# plugins, and themes. Aliases can be placed here, though ohmyzsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.ohmyzsh"
#

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi
export CLOUDSDK_PYTHON=python3

fpath=($fpath "/home/gordonchiam/.zfunctions")


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/gchiam/.sdkman"
[[ -s "/Users/gchiam/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/gchiam/.sdkman/bin/sdkman-init.sh"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init zsh)"

PATH="/Users/gchiam/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/gchiam/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/gchiam/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/gchiam/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/gchiam/perl5"; export PERL_MM_OPT;

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"
eval "$(rbenv init - zsh)"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@ ;}
