#!/usr/bin/env bats

# Mock HOME for testing
setup() {
    TEST_HOME="${BATS_TMPDIR}/test_home"
    mkdir -p "$TEST_HOME"
    ORIGINAL_HOME="$HOME"
    export HOME="$TEST_HOME"
    
    # Source the utility script
    # We use source inside a function so we can catch errors if needed
    if [[ -f "./bin/lib/utils.sh" ]]; then
        source "./bin/lib/utils.sh"
    fi
}

teardown() {
    export HOME="$ORIGINAL_HOME"
    rm -rf "$TEST_HOME"
}

@test "get_xdg_path: returns XDG_STATE_HOME if set" {
    export XDG_STATE_HOME="$TEST_HOME/custom_state"
    result=$(get_xdg_path "STATE")
    [[ "$result" == "$TEST_HOME/custom_state" ]]
}

@test "get_xdg_path: returns default state path if XDG_STATE_HOME not set" {
    unset XDG_STATE_HOME
    result=$(get_xdg_path "STATE")
    [[ "$result" == "$TEST_HOME/.local/state" ]]
}

@test "get_xdg_path: returns XDG_DATA_HOME if set" {
    export XDG_DATA_HOME="$TEST_HOME/custom_data"
    result=$(get_xdg_path "DATA")
    [[ "$result" == "$TEST_HOME/custom_data" ]]
}

@test "get_xdg_path: returns default data path if XDG_DATA_HOME not set" {
    unset XDG_DATA_HOME
    result=$(get_xdg_path "DATA")
    [[ "$result" == "$TEST_HOME/.local/share" ]]
}

@test "get_xdg_path: returns XDG_CACHE_HOME if set" {
    export XDG_CACHE_HOME="$TEST_HOME/custom_cache"
    result=$(get_xdg_path "CACHE")
    [[ "$result" == "$TEST_HOME/custom_cache" ]]
}

@test "get_xdg_path: returns default cache path if XDG_CACHE_HOME not set" {
    unset XDG_CACHE_HOME
    result=$(get_xdg_path "CACHE")
    [[ "$result" == "$TEST_HOME/.cache" ]]
}

@test "get_xdg_path: returns XDG_CONFIG_HOME if set" {
    export XDG_CONFIG_HOME="$TEST_HOME/custom_config"
    result=$(get_xdg_path "CONFIG")
    [[ "$result" == "$TEST_HOME/custom_config" ]]
}

@test "get_xdg_path: returns default config path if XDG_CONFIG_HOME not set" {
    unset XDG_CONFIG_HOME
    result=$(get_xdg_path "CONFIG")
    [[ "$result" == "$TEST_HOME/.config" ]]
}

@test "get_xdg_path: returns provided fallback for unknown types" {
    result=$(get_xdg_path "UNKNOWN" "/tmp/fallback")
    [[ "$result" == "/tmp/fallback" ]]
}
