#!/usr/bin/env bats

setup() {
    # Mock defaults command
    mock_defaults() {
        if [[ "$*" == "read -g AppleInterfaceStyle" ]]; then
            if [[ "$MOCK_THEME" == "Dark" ]]; then
                echo "Dark"
                return 0
            else
                echo "Error: The Windows key has not been defined" >&2
                return 1
            fi
        fi
        command defaults "$@"
    }
    export -f mock_defaults
    alias defaults=mock_defaults
}

@test "detects Dark mode correctly" {
    export MOCK_THEME="Dark"
    run bin/theme-sync.sh --get
    [ "$status" -eq 0 ]
    [ "$output" = "Dark" ]
}

@test "detects Light mode correctly" {
    export MOCK_THEME="Light"
    run bin/theme-sync.sh --get
    [ "$status" -eq 0 ]
    [ "$output" = "Light" ]
}

@test "returns correct flavor for Dark mode" {
    export MOCK_THEME="Dark"
    run bin/theme-sync.sh --flavor
    [ "$status" -eq 0 ]
    [ "$output" = "frappe" ]
}

@test "returns correct flavor for Light mode" {
    export MOCK_THEME="Light"
    run bin/theme-sync.sh --flavor
    [ "$status" -eq 0 ]
    [ "$output" = "latte" ]
}
