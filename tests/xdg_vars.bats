#!/usr/bin/env bats

# Tests for the zsh environment bootstrap:
#   - stow/zsh/.config/zsh/.zshenv sets XDG variables and ZDOTDIR
#   - bin/setup-zshenv.sh makes the untracked ~/.zshenv load it

setup() {
    REPO_ROOT="$PWD"
    TEST_HOME="$(mktemp -d)"
    # Simulate a stowed zsh package (tree-folded ~/.config/zsh symlink)
    mkdir -p "$TEST_HOME/.config"
    ln -s "$REPO_ROOT/stow/zsh/.config/zsh" "$TEST_HOME/.config/zsh"
}

teardown() {
    rm -rf "$TEST_HOME"
}

# Run zsh with a clean environment so nothing leaks in from the host shell
clean_zsh() {
    env -i HOME="$TEST_HOME" PATH="$PATH" "$@" zsh -c "$ZSH_COMMAND"
}

@test "config .zshenv exports XDG variables" {
    ZSH_COMMAND='source "$HOME/.config/zsh/.zshenv"; echo "$XDG_CONFIG_HOME:$XDG_DATA_HOME:$XDG_STATE_HOME:$XDG_CACHE_HOME"'
    run clean_zsh
    [ "$status" -eq 0 ]
    [ "$output" = "$TEST_HOME/.config:$TEST_HOME/.local/share:$TEST_HOME/.local/state:$TEST_HOME/.cache" ]
}

@test "config .zshenv exports ZDOTDIR" {
    ZSH_COMMAND='source "$HOME/.config/zsh/.zshenv"; echo "$ZDOTDIR"'
    run clean_zsh
    [ "$status" -eq 0 ]
    [ "$output" = "$TEST_HOME/.config/zsh" ]
}

@test "setup-zshenv.sh creates ~/.zshenv that sets ZDOTDIR for new shells" {
    HOME="$TEST_HOME" run bin/setup-zshenv.sh
    [ "$status" -eq 0 ]
    [ -f "$TEST_HOME/.zshenv" ] && [ ! -L "$TEST_HOME/.zshenv" ]

    ZSH_COMMAND='echo "$ZDOTDIR"'
    run clean_zsh
    [ "$output" = "$TEST_HOME/.config/zsh" ]
}

@test "setup-zshenv.sh keeps existing content, including an early return" {
    cat > "$TEST_HOME/.zshenv" <<'EOF'
# Begin JAMF Managed
[[ -f "$HOME/.missing-ca-bundle.pem" ]] || return
export SHOULD_NOT_BE_SET=1
# End JAMF Managed
EOF
    HOME="$TEST_HOME" run bin/setup-zshenv.sh
    [ "$status" -eq 0 ]
    grep -q "Begin JAMF Managed" "$TEST_HOME/.zshenv"

    ZSH_COMMAND='echo "$ZDOTDIR:${SHOULD_NOT_BE_SET:-unset}"'
    run clean_zsh
    [ "$output" = "$TEST_HOME/.config/zsh:unset" ]
}

@test "setup-zshenv.sh is idempotent" {
    HOME="$TEST_HOME" run bin/setup-zshenv.sh
    HOME="$TEST_HOME" run bin/setup-zshenv.sh
    [ "$status" -eq 0 ]
    [[ "$output" == *"already bootstraps"* ]]
    [ "$(grep -c "dotfiles zsh bootstrap >>>" "$TEST_HOME/.zshenv")" -eq 1 ]
}

@test "setup-zshenv.sh replaces a stale symlink with a regular file" {
    echo 'export KEPT_FROM_LINK=1' > "$TEST_HOME/old-zshenv"
    ln -s "$TEST_HOME/old-zshenv" "$TEST_HOME/.zshenv"

    HOME="$TEST_HOME" run bin/setup-zshenv.sh
    [ "$status" -eq 0 ]
    [ ! -L "$TEST_HOME/.zshenv" ]
    grep -q "KEPT_FROM_LINK" "$TEST_HOME/.zshenv"
    # The original link target is untouched
    [ "$(cat "$TEST_HOME/old-zshenv")" = 'export KEPT_FROM_LINK=1' ]
}

@test "preset ZDOTDIR still loads ~/.zshenv exactly once" {
    HOME="$TEST_HOME" bin/setup-zshenv.sh >/dev/null
    echo 'export MACHINE_SETTING=1; echo loaded >> "$HOME/load-count"' >> "$TEST_HOME/.zshenv"

    # As WezTerm does: ZDOTDIR is set, so zsh skips ~/.zshenv on its own
    ZSH_COMMAND='echo "$ZDOTDIR:${MACHINE_SETTING:-unset}"'
    run clean_zsh ZDOTDIR="$TEST_HOME/.config/zsh"
    [ "$output" = "$TEST_HOME/.config/zsh:1" ]
    [ "$(wc -l < "$TEST_HOME/load-count")" -eq 1 ]
}

@test "bootstrapped ~/.zshenv loads machine settings exactly once" {
    HOME="$TEST_HOME" bin/setup-zshenv.sh >/dev/null
    echo 'export MACHINE_SETTING=1; echo loaded >> "$HOME/load-count"' >> "$TEST_HOME/.zshenv"

    ZSH_COMMAND='echo "$ZDOTDIR:${MACHINE_SETTING:-unset}"'
    run clean_zsh
    [ "$output" = "$TEST_HOME/.config/zsh:1" ]
    [ "$(wc -l < "$TEST_HOME/load-count")" -eq 1 ]
}
