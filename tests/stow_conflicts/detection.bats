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
    
    # Pipe 's' to avoid hanging on read
    run bash -c "source bin/setup-stow.sh && echo 's' | check_stow_conflicts test_pkg"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Conflict at"* ]]
}

@test "detects conflict when target is a symlink to somewhere else" {
    mkdir -p "$MOCK_HOME/.config"
    mkdir -p "$TEST_DIR/other_place"
    echo "other content" > "$TEST_DIR/other_place/other_file"
    ln -s "$TEST_DIR/other_place/other_file" "$MOCK_HOME/.config/test_file"
    
    # Pipe 's' to avoid hanging on read
    run bash -c "source bin/setup-stow.sh && echo 's' | check_stow_conflicts test_pkg"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Conflict at"* ]]
}

@test "detects no conflict when target is already the correct symlink" {
    mkdir -p "$MOCK_HOME/.config"
    ln -s "$MOCK_DOTFILES/stow/test_pkg/.config/test_file" "$MOCK_HOME/.config/test_file"
    
    run bash -c "source bin/setup-stow.sh && check_stow_conflicts test_pkg"
    [ "$status" -eq 0 ]
}

@test "detects no conflict when target is reached through a folded directory symlink" {
    # stow tree folding: ~/.config/test_dir -> stow/test_pkg/.config/test_dir
    mkdir -p "$MOCK_DOTFILES/stow/test_pkg/.config/test_dir"
    echo "nested content" > "$MOCK_DOTFILES/stow/test_pkg/.config/test_dir/nested_file"
    mkdir -p "$MOCK_HOME/.config"
    ln -s "$MOCK_DOTFILES/stow/test_pkg/.config/test_file" "$MOCK_HOME/.config/test_file"
    ln -s "$MOCK_DOTFILES/stow/test_pkg/.config/test_dir" "$MOCK_HOME/.config/test_dir"

    run bash -c "source bin/setup-stow.sh && check_stow_conflicts test_pkg"
    [ "$status" -eq 0 ]
    [[ "$output" != *"Conflict at"* ]]
}

@test "is idempotent after a real stow run" {
    command -v stow >/dev/null || skip "stow not installed"
    mkdir -p "$MOCK_DOTFILES/stow/test_pkg/.config/test_dir"
    echo "nested content" > "$MOCK_DOTFILES/stow/test_pkg/.config/test_dir/nested_file"
    stow -d "$MOCK_DOTFILES/stow" -t "$MOCK_HOME" test_pkg

    run bash -c "source bin/setup-stow.sh && check_stow_conflicts test_pkg"
    [ "$status" -eq 0 ]
    [[ "$output" != *"Conflict at"* ]]
}

@test "detects no conflict for package symlinks whose target is missing" {
    # e.g. theme files linked from an uninitialised git submodule
    mkdir -p "$MOCK_DOTFILES/stow/test_pkg/.config/test_dir"
    ln -s "$TEST_DIR/missing_submodule/theme.toml" "$MOCK_DOTFILES/stow/test_pkg/.config/test_dir/theme.toml"
    mkdir -p "$MOCK_HOME/.config"
    ln -s "$MOCK_DOTFILES/stow/test_pkg/.config/test_file" "$MOCK_HOME/.config/test_file"
    ln -s "$MOCK_DOTFILES/stow/test_pkg/.config/test_dir" "$MOCK_HOME/.config/test_dir"

    run bash -c "source bin/setup-stow.sh && check_stow_conflicts test_pkg < /dev/null"
    [ "$status" -eq 0 ]
    [[ "$output" != *"Conflict at"* ]]
}

@test "detects no conflict for a relative per-file stow symlink" {
    mkdir -p "$MOCK_HOME/.config"
    ln -s "../../dotfiles/stow/test_pkg/.config/test_file" "$MOCK_HOME/.config/test_file"

    run bash -c "source bin/setup-stow.sh && check_stow_conflicts test_pkg < /dev/null"
    [ "$status" -eq 0 ]
}
