#!/usr/bin/env bats

setup() {
    # Create a temporary directory for the mock environment
    TEST_DIR=$(mktemp -d)
    MOCK_HOME="$TEST_DIR/home"
    MOCK_DOTFILES="$TEST_DIR/dotfiles"
    mkdir -p "$MOCK_HOME"
    mkdir -p "$MOCK_DOTFILES/stow/test_pkg/.config"
    
    # Create a sample file in the dotfiles
    echo "dotfiles content" > "$MOCK_DOTFILES/stow/test_pkg/.config/test_file"
    
    # Export variables for the script to use
    export HOME="$MOCK_HOME"
    export DOTFILES_DIR="$MOCK_DOTFILES"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "detects no conflict when target doesn't exist" {
    # No file in MOCK_HOME/.config/test_file
    run bash -c "source bin/setup-stow.sh && check_stow_conflicts test_pkg"
    [ "$status" -eq 0 ]
}

@test "detects conflict when target is a regular file" {
    mkdir -p "$MOCK_HOME/.config"
    echo "existing content" > "$MOCK_HOME/.config/test_file"
    
    run bash -c "source bin/setup-stow.sh && check_stow_conflicts test_pkg"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Conflict detected"* ]]
}

@test "detects conflict when target is a symlink to somewhere else" {
    mkdir -p "$MOCK_HOME/.config"
    mkdir -p "$TEST_DIR/other_place"
    echo "other content" > "$TEST_DIR/other_place/other_file"
    ln -s "$TEST_DIR/other_place/other_file" "$MOCK_HOME/.config/test_file"
    
    run bash -c "source bin/setup-stow.sh && check_stow_conflicts test_pkg"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Conflict detected"* ]]
}

@test "detects no conflict when target is already the correct symlink" {
    mkdir -p "$MOCK_HOME/.config"
    ln -s "$MOCK_DOTFILES/stow/test_pkg/.config/test_file" "$MOCK_HOME/.config/test_file"
    
    run bash -c "source bin/setup-stow.sh && check_stow_conflicts test_pkg"
    [ "$status" -eq 0 ]
}
