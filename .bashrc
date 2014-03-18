[ -f /etc/bashrc ] && source /etc/bashrc

# Tell the terminal about the working directory at each prompt.
if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL,
        # including the host name to disambiguate local vs.
        # remote connections. Percent-escape spaces.
        local SEARCH=' '
        local REPLACE='%20'
        local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
        printf '\e]7;%s\a' "$PWD_URL"
    }
    PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
fi

[ -n "$PS1" ] && source ~/.bash_profile

test -d $HOME/opt/android-sdk/platform-tools && PATH=$PATH:$HOME/opt/android-sdk/platform-tools
test -d $HOME/.rvm/bin && (which rvm > /dev/null 2>&1) || PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting
