# vim: set filetype=sh:

#BEGIN ZETUP
eval "$( /opt/homebrew/bin/brew shellenv )"
[ "${commands[zetup]}" ] > /dev/null && eval "$( zetup env shell-exports --zsh )"
#END ZETUP

# SSH Agent
eval "$(ssh-agent)"
if [ -f ~/.ssh/gchiam@zendesk.com ]; then
    ssh-add --apple-use-keychain ~/.ssh/gchiam@zendesk.com
fi
