#!/usr/bin/env bats

# Tests for bin/setup.sh. Every run uses an isolated HOME (common_setup) and
# mocked external commands, so the tests never touch the real home directory,
# never install anything and do not depend on Homebrew being present.

setup() {
    load "helpers/test_helper"
    common_setup

    # Tools setup.sh checks for or calls; mocked so nothing real runs
    mock_command stow
    mock_command gitleaks
    mock_command brew
    mock_command bat
    mock_command fast-theme
}

teardown() {
    common_teardown
}

run_setup() {
    run bin/setup.sh "$@"
}

@test "setup.sh exits with error for invalid argument" {
    run_setup --invalid-arg
    assert_failure
    assert_output --partial "Error: Unknown argument: --invalid-arg"
}

@test "setup.sh enters debug mode with --debug argument" {
    run_setup --debug
    assert_success
    assert_output --partial "Debug mode is enabled."
}

@test "setup.sh links the dotfiles directory inside HOME" {
    run_setup
    assert_success
    assert [ -L "$TEST_HOME/dotfiles" ]
    assert_equal "$(cd "$TEST_HOME/dotfiles" && pwd -P)" "$(cd "$PROJECT_ROOT" && pwd -P)"
}

@test "setup.sh stows packages into the isolated HOME" {
    run_setup
    assert_success
    assert_command_called stow "--target=$TEST_HOME"
}

@test "setup.sh does not install Homebrew when stow and gitleaks exist" {
    run_setup
    assert_success
    assert [ ! -f "$MOCK_BIN_DIR/brew.log" ]
}

@test "setup.sh writes its generated files only inside HOME" {
    run_setup
    assert_success
    assert_file_exists "$TEST_HOME/fleet.properties"
    assert_file_contains "$TEST_HOME/.zshenv" "dotfiles zsh bootstrap"
    assert_command_called bat "cache --build"
    assert_command_called fast-theme "XDG:catppuccin-frappe"
}
