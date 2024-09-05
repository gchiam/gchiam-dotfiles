# vim: set filetype=sh:

#BEGIN ZETUP
eval "$(/opt/homebrew/bin/brew shellenv)"
[ $commands[zetup] ] > /dev/null && eval "$(zetup env shell-exports --zsh)"
#END ZETUP
