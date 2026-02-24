#!/bin/bash

# Resolve project root (one level up from tests/helpers)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Load BATS support libraries
load "${PROJECT_ROOT}/tests/libs/bats-support/load.bash"
load "${PROJECT_ROOT}/tests/libs/bats-assert/load.bash"
load "${PROJECT_ROOT}/tests/libs/bats-file/load.bash"

# Mocking infrastructure
# Creates a temporary directory for mock binaries and adds it to PATH
setup_mocks() {
    MOCK_BIN_DIR="$(mktemp -d)"
    export PATH="${MOCK_BIN_DIR}:${PATH}"
    export MOCK_BIN_DIR
}

# Cleanup mock binaries
teardown_mocks() {
    if [[ -d "${MOCK_BIN_DIR:-}" ]]; then
        rm -rf "$MOCK_BIN_DIR"
    fi
}

# Create a mock for a command
# Usage: mock_command <command_name> [exit_code] [output_string]
mock_command() {
    local cmd="$1"
    local exit_code="${2:-0}"
    local output="${3:-}"
    local mock_file="${MOCK_BIN_DIR}/${cmd}"
    local log_file="${MOCK_BIN_DIR}/${cmd}.log"

    cat > "$mock_file" << EOF
#!/bin/bash
# Log arguments
echo "\$*" >> "$log_file"
# Print output if any
[[ -n "$output" ]] && echo "$output"
# Exit with specified code
exit $exit_code
EOF
    chmod +x "$mock_file"
}

# Check if a command was called with specific arguments
# Usage: assert_command_called <command_name> <expected_args_regex>
assert_command_called() {
    local cmd="$1"
    local pattern="$2"
    local log_file="${MOCK_BIN_DIR}/${cmd}.log"

    if [[ ! -f "$log_file" ]]; then
        fail "Command '$cmd' was never called"
    fi

    if ! grep -qE "$pattern" "$log_file"; then
        fail "Command '$cmd' was not called with arguments matching: $pattern. Actual calls: $(cat "$log_file")"
    fi
}

# Common setup for all tests
common_setup() {
    # Set up isolated home directory
    export TEST_HOME="${BATS_TMPDIR}/test_home_$(date +%s)_${RANDOM}"
    mkdir -p "$TEST_HOME"
    
    # Preserve original home and environment
    export ORIGINAL_HOME="$HOME"
    export HOME="$TEST_HOME"
    
    # Setup mocks
    setup_mocks
}

# Common teardown for all tests
common_teardown() {
    # Restore home
    export HOME="$ORIGINAL_HOME"
    
    # Cleanup
    rm -rf "$TEST_HOME"
    teardown_mocks
}
