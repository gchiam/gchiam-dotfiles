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
    # Simulate typing 'b'
    run bash -c "source bin/setup-stow.sh && echo 'b' | check_stow_conflicts test_pkg"
    [ "$status" -eq 0 ]
    [ -f "$MOCK_HOME/.config/test_file.bak" ]
    [ "$(cat "$MOCK_HOME/.config/test_file.bak")" = "existing content" ]
    [ ! -e "$MOCK_HOME/.config/test_file" ]
}

@test "resolves conflict with overwrite" {
    # Simulate typing 'o'
    run bash -c "source bin/setup-stow.sh && echo 'o' | check_stow_conflicts test_pkg"
    [ "$status" -eq 0 ]
    [ ! -e "$MOCK_HOME/.config/test_file" ]
}

@test "resolves conflict with skip" {
    # Simulate typing 's'
    run bash -c "source bin/setup-stow.sh && echo 's' | check_stow_conflicts test_pkg"
    [ "$status" -eq 1 ]
    [ -f "$MOCK_HOME/.config/test_file" ]
    [ "$(cat "$MOCK_HOME/.config/test_file")" = "existing content" ]
}
