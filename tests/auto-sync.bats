#!/usr/bin/env bats

setup() {
    load "helpers/test_helper"
    common_setup

    # Mock dependencies used during sourcing
    get_xdg_path() { echo "$TEST_HOME"; }
    ensure_dir() { mkdir -p "$(dirname "$1")"; }
    
    # Source the script
    source "${PROJECT_ROOT}/bin/auto-sync.sh"
    
    # Redefine LAST_SYNC_FILE to point to our test home
    LAST_SYNC_FILE="$TEST_HOME/last-sync"
}

teardown() {
    common_teardown
}

@test "needs_sync: returns 0 if LAST_SYNC_FILE does not exist" {
    rm -f "$LAST_SYNC_FILE"
    run needs_sync
    assert_success
}

@test "needs_sync: returns 0 if interval has passed" {
    local eight_days_ago=$(($(date +%s) - (8 * 86400)))
    echo "$eight_days_ago" > "$LAST_SYNC_FILE"
    CHECK_INTERVAL=7
    run needs_sync
    assert_success
}

@test "needs_sync: returns 1 if interval has not passed" {
    local one_day_ago=$(($(date +%s) - (1 * 86400)))
    echo "$one_day_ago" > "$LAST_SYNC_FILE"
    CHECK_INTERVAL=7
    run needs_sync
    assert_failure
}

@test "commit_updates: commits changes when submodules are updated" {
    # Mock git submodule status to return a changed submodule
    # Format: +commit_hash path (branch)
    git() {
        if [[ "$1" == "submodule" && "$2" == "status" ]]; then
            echo "+1234567 external/test-submodule (heads/main)"
        elif [[ "$1" == "add" ]]; then
            return 0
        elif [[ "$1" == "commit" ]]; then
            # Record commit message for verification
            echo "COMMIT_MSG: $*" >> "$TEST_HOME/git_calls.log"
            return 0
        else
            command git "$@"
        fi
    }
    
    # Export the mock function
    export -f git
    
    run commit_updates
    assert_success
    
    # Verify git commit was called with expected message part
    assert_file_contains "$TEST_HOME/git_calls.log" "Update test-submodule submodule"
    
    # Verify last sync file was updated
    assert_file_exists "$LAST_SYNC_FILE"
}
