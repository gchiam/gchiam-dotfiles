#!/usr/bin/env bats

setup() {
    TEST_DIR=$(mktemp -d)
    MOCK_HOME="$TEST_DIR/home"
    MOCK_DOTFILES="$TEST_DIR/dotfiles"
    mkdir -p "$MOCK_HOME/.config"
    mkdir -p "$MOCK_DOTFILES/stow/test_pkg/.config"
    
    echo "dotfiles content" > "$MOCK_DOTFILES/stow/test_pkg/.config/test_file"
    echo "existing content" > "$MOCK_HOME/.config/test_file"
    
    export HOME="$MOCK_HOME"
    export DOTFILES_DIR="$MOCK_DOTFILES"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "resolves conflict with backup" {
    run bash -c "source bin/setup-stow.sh && echo 'b' | check_stow_conflicts test_pkg"
    [ "$status" -eq 0 ]
    [ -f "$MOCK_HOME/.config/test_file.bak" ]
    [ "$(cat "$MOCK_HOME/.config/test_file.bak")" = "existing content" ]
    [ ! -e "$MOCK_HOME/.config/test_file" ]
}

@test "resolves conflict with overwrite" {
    run bash -c "source bin/setup-stow.sh && echo 'o' | check_stow_conflicts test_pkg"
    [ "$status" -eq 0 ]
    [ ! -e "$MOCK_HOME/.config/test_file" ]
}

@test "resolves conflict with skip" {
    run bash -c "source bin/setup-stow.sh && echo 's' | check_stow_conflicts test_pkg"
    [ "$status" -eq 1 ]
    [ -f "$MOCK_HOME/.config/test_file" ]
    [ "$(cat "$MOCK_HOME/.config/test_file")" = "existing content" ]
}

@test "skips automatically in non-interactive mode" {
    run bash -c "source bin/setup-stow.sh && NON_INTERACTIVE=true check_stow_conflicts test_pkg"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Non-interactive mode: Skipping"* ]]
    [ -f "$MOCK_HOME/.config/test_file" ]
}

@test "never deletes repository files reached through a folded directory symlink" {
    # A folded directory owned by another package, containing a file that
    # test_pkg also wants to place there.
    mkdir -p "$MOCK_DOTFILES/stow/other_pkg/.config/shared_dir"
    echo "repo content" > "$MOCK_DOTFILES/stow/other_pkg/.config/shared_dir/file"
    mkdir -p "$MOCK_DOTFILES/stow/test_pkg/.config/shared_dir"
    echo "test_pkg content" > "$MOCK_DOTFILES/stow/test_pkg/.config/shared_dir/file"
    rm -f "$MOCK_HOME/.config/test_file"
    ln -s "$MOCK_DOTFILES/stow/test_pkg/.config/test_file" "$MOCK_HOME/.config/test_file"
    ln -s "$MOCK_DOTFILES/stow/other_pkg/.config/shared_dir" "$MOCK_HOME/.config/shared_dir"

    run bash -c "source bin/setup-stow.sh && echo 'o' | check_stow_conflicts test_pkg"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Refusing to modify"* ]]
    [ "$(cat "$MOCK_DOTFILES/stow/other_pkg/.config/shared_dir/file")" = "repo content" ]
}

@test "skips instead of looping forever when input ends" {
    # Portable watchdog (macOS has no timeout(1)): kill the check after 10s
    # so a regression fails the test instead of hanging CI.
    run bash -c '
        source bin/setup-stow.sh
        check_stow_conflicts test_pkg < /dev/null &
        pid=$!
        ( sleep 10; kill "$pid" ) >/dev/null 2>&1 3>&- &
        watchdog=$!
        wait "$pid"
        status=$?
        kill "$watchdog" 2>/dev/null
        exit "$status"
    '
    [ "$status" -eq 1 ]
    [[ "$output" == *"No input available"* ]]
    [ "$(cat "$MOCK_HOME/.config/test_file")" = "existing content" ]
}
