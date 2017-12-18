# vim: set filetype=sh:


PATH=/usr/local/sbin:/usr/local/bin:$PATH
PATH=$HOME/.local/bin:$HOME/bin:$PATH
[[ -d "$HOME/opt/android-sdk/tools" ]] && PATH=$PATH:$HOME/opt/android-sdk/tools
[[ -d "$HOME/opt/android-sdk/platform-tools" ]] && PATH=$PATH:$HOME/opt/android-sdk/platform-tools
[[ -d "$HOME/.rvm/bin" ]] && (which rvm > /dev/null 2>&1) || PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -s "$HOME/.linuxbrew/bin" ]] && PATH=$HOME/.linuxbrew/bin:$PATH
[[ -s "$HOME/.linuxbrew/sbin" ]] && PATH=$HOME/.linuxbrew/sbin:$PATH
[[ -d "$HOME/.cargo/bin" ]] && PATH="$HOME/.cargo/bin:$PATH"

# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
[[ -d /Library/Frameworks/Python.framework/Versions/3.4/bin ]] && PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"

export PATH

# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{bash_extra,bash_prompt,bash_exports,bash_aliases,bash_functions,bash_completion,bash_completion-homebrew,bash_local,bash_private,bash_motd}; do
    [ -r "$file" ] && . "$file"
done
unset file
export VIM_COLORSCHEME=${VIM_COLORSCHEME:-gruvbox}

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend


# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash
