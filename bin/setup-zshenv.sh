#!/bin/bash
set -euo pipefail

# Ensure ~/.zshenv bootstraps the modular zsh config in ~/.config/zsh.
#
# ~/.zshenv is a real, untracked file because JAMF/Netskope manage it on work
# machines; stowing it let them rewrite the repository through the symlink.
# Instead, this script adds a small marked block at the top of ~/.zshenv that
# sources ~/.config/zsh/.zshenv (which sets ZDOTDIR). It is idempotent, keeps
# any existing content, and can be re-run if the file is ever rewritten.

BLOCK_BEGIN="# >>> dotfiles zsh bootstrap >>>"

zshenv_path() {
    echo "$HOME/.zshenv"
}

bootstrap_block() {
    cat <<'BLOCK'
# >>> dotfiles zsh bootstrap >>>
# Managed by dotfiles bin/setup-zshenv.sh: loads ~/.config/zsh/.zshenv (sets ZDOTDIR).
if [[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshenv" ]]; then
    _DOTFILES_FROM_HOME_ZSHENV=1
    source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshenv"
    unset _DOTFILES_FROM_HOME_ZSHENV
fi
# <<< dotfiles zsh bootstrap <<<
BLOCK
}

has_bootstrap_block() {
    grep -qF "$BLOCK_BEGIN" "$1" 2>/dev/null
}

# A ~/.zshenv symlink left by an older stow layout points into the repository
# (or nowhere, now that stow/zsh/.zshenv is gone). Replace it with a real file
# that keeps whatever content it currently resolves to.
replace_symlink_with_file() {
    local target="$1"
    local content=""

    if [[ -L "$target" ]]; then
        if [[ -r "$target" ]]; then
            content=$(cat "$target")
        fi
        rm "$target"
        if [[ -n "$content" ]]; then
            printf '%s\n' "$content" > "$target"
        fi
        echo "Replaced symlink $target with a regular file"
    fi
}

prepend_bootstrap_block() {
    local target="$1"
    local tmp

    tmp=$(mktemp)
    {
        bootstrap_block
        if [[ -s "$target" ]]; then
            echo
            cat "$target"
        fi
    } > "$tmp"
    # Write back into the same file so its permissions and ownership are kept
    cat "$tmp" > "$target"
    rm -f "$tmp"
}

main() {
    local target
    target=$(zshenv_path)

    replace_symlink_with_file "$target"

    if has_bootstrap_block "$target"; then
        echo "✓ $target already bootstraps the zsh config"
        return 0
    fi

    prepend_bootstrap_block "$target"
    echo "✓ Added zsh bootstrap block to $target"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
