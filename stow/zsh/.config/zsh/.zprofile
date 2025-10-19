# shellcheck disable=SC2148
# vim: set filetype=sh:
# Login shell configuration - runs once per login session

#BEGIN ZETUP
eval "$( /opt/homebrew/bin/brew shellenv )"
[ "${commands[zetup]}" ] > /dev/null && eval "$( zetup env shell-exports --zsh )"
#END ZETUP

# SSH Agent Management (optimized)
# Only start ssh-agent if one isn't already running
if ! pgrep -x ssh-agent > /dev/null 2>&1; then
    # Start ssh-agent and export variables
    eval "$(ssh-agent -s)" > /dev/null
fi

# Add SSH keys if they exist and aren't already loaded
add_ssh_key() {
    local key_path="$1"
    if [[ -f "$key_path" ]]; then
        # Check if key is already loaded
        if ! ssh-add -l 2>/dev/null | grep -q "$key_path"; then
            ssh-add --apple-use-keychain "$key_path" 2>/dev/null
        fi
    fi
}

# Add common SSH keys
add_ssh_key "$HOME/.ssh/gchiam@zendesk.com"

# Clean up function
unset -f add_ssh_key
