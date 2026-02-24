#!/usr/bin/env bats

setup() {
    load "helpers/test_helper"
    common_setup

    # Mock dependencies used during sourcing
    get_xdg_path() { echo "$TEST_HOME"; }
    ensure_dir() { mkdir -p "$(dirname "$1")"; }
    
    # Source the script
    source "${PROJECT_ROOT}/bin/setup-profile.sh"
    
    # Redefine CURRENT_PROFILE_FILE to point to our test home
    CURRENT_PROFILE_FILE="$TEST_HOME/profile"
}

teardown() {
    common_teardown
}

@test "get_current_profile: returns 'none' if file doesn't exist" {
    rm -f "$CURRENT_PROFILE_FILE"
    run get_current_profile
    assert_success
    assert_output "none"
}

@test "set_current_profile: saves profile to file" {
    run set_current_profile "work"
    assert_success
    assert_file_contains "$CURRENT_PROFILE_FILE" "work"
}

@test "get_current_profile: returns saved profile" {
    echo "personal" > "$CURRENT_PROFILE_FILE"
    run get_current_profile
    assert_success
    assert_output "personal"
}
