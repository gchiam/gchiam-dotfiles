#!/usr/bin/env bats

# Mock HOME for testing
setup() {
    TEST_HOME="${BATS_TMPDIR}/test_home_xdg"
    mkdir -p "$TEST_HOME"
}

teardown() {
    rm -rf "$TEST_HOME"
}

@test "XDG variables are exported in .zshenv" {
    # Source .zshenv in a clean zsh environment with unset XDG vars
    result=$(HOME="$TEST_HOME" zsh -c 'unset XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME; source ./stow/zsh/.zshenv >/dev/null 2>&1; echo "$XDG_CONFIG_HOME:$XDG_DATA_HOME:$XDG_STATE_HOME:$XDG_CACHE_HOME"')
    
    expected="$TEST_HOME/.config:$TEST_HOME/.local/share:$TEST_HOME/.local/state:$TEST_HOME/.cache"
    [[ "$result" == "$expected" ]]
}

@test "ZDOTDIR is exported in .zshenv" {
    result=$(HOME="$TEST_HOME" zsh -c 'unset XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME; source ./stow/zsh/.zshenv >/dev/null 2>&1; echo "$ZDOTDIR"')
    [[ "$result" == "$TEST_HOME/.config/zsh" ]]
}
