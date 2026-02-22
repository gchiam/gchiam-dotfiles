#!/usr/bin/env bats

setup() {
    MOCK_BIN_DIR=$(mktemp -d)
    export PATH="$MOCK_BIN_DIR:$PATH"
    
    cat > "$MOCK_BIN_DIR/defaults" << 'EOF'
#!/bin/bash
if [[ "$*" == "read -g AppleInterfaceStyle" ]]; then
    if [[ "$MOCK_THEME" == "Dark" ]]; then
        echo "Dark"
        exit 0
    else
        echo "Error: The Windows key has not been defined" >&2
        exit 1
    fi
fi
exec /usr/bin/defaults "$@"
EOF
    chmod +x "$MOCK_BIN_DIR/defaults"

    # Mock fswatch to run once and exit
    cat > "$MOCK_BIN_DIR/fswatch" << 'EOF'
#!/bin/bash
echo "changed"
EOF
    chmod +x "$MOCK_BIN_DIR/fswatch"

    # Mock pkill
    cat > "$MOCK_BIN_DIR/pkill" << 'EOF'
#!/bin/bash
echo "pkill $@" >> "$MOCK_BIN_DIR/pkill_log"
EOF
    chmod +x "$MOCK_BIN_DIR/pkill"

    # Mock tmux
    cat > "$MOCK_BIN_DIR/tmux" << 'EOF'
#!/bin/bash
echo "tmux $@" >> "$MOCK_BIN_DIR/tmux_log"
EOF
    chmod +x "$MOCK_BIN_DIR/tmux"

    export STATE_FILE=$(mktemp)
}

teardown() {
    rm -rf "$MOCK_BIN_DIR"
    rm -f "$STATE_FILE"
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

@test "broadcasts flavor to state file" {
    export MOCK_THEME="Dark"
    export CATPPUCCIN_STATE_FILE="$STATE_FILE"
    run bin/theme-sync.sh --watch
    [ "$status" -eq 0 ]
    [ "$(cat "$STATE_FILE")" = "frappe" ]
}

@test "broadcasts signal to zsh sessions" {
    export MOCK_THEME="Dark"
    export CATPPUCCIN_STATE_FILE="$STATE_FILE"
    run bin/theme-sync.sh --watch
    [ "$status" -eq 0 ]
    grep -q "pkill -USR1 zsh" "$MOCK_BIN_DIR/pkill_log"
}
