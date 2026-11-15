#!/usr/bin/env bats

# Tests for bin/test.sh. The runner finds tests relative to its own location,
# so each test copies it into a throwaway repository with fixture tests. This
# keeps it from ever running (and recursing into) the real test suite.

setup() {
    FAKE_REPO="$(mktemp -d)"
    mkdir -p "$FAKE_REPO/bin" "$FAKE_REPO/tests"
    cp bin/test.sh "$FAKE_REPO/bin/test.sh"
}

teardown() {
    rm -rf "$FAKE_REPO"
}

# Write a fixture test file whose single test runs the given command.
# printf keeps the fixture's test line out of this file's own source,
# which bats would otherwise parse as a test.
write_test() {
    local path="$FAKE_REPO/tests/$1" command="$2"
    mkdir -p "$(dirname "$path")"
    printf '#!/usr/bin/env bats\n@%s "%s" { %s; }\n' "test" "$1" "$command" > "$path"
}

@test "runs every file and reports all failures, not just the first" {
    write_test a_fail.bats false
    write_test b_pass.bats true
    write_test c_fail.bats false

    run "$FAKE_REPO/bin/test.sh"
    [ "$status" -eq 1 ]
    [[ "$output" == *"b_pass.bats passed"* ]]
    [[ "$output" == *"2 of 3 test files failed"* ]]
    [[ "$output" == *"- tests/a_fail.bats"* ]]
    [[ "$output" == *"- tests/c_fail.bats"* ]]
}

@test "succeeds when every file passes" {
    write_test a_pass.bats true
    write_test b_pass.bats true

    run "$FAKE_REPO/bin/test.sh"
    [ "$status" -eq 0 ]
    [[ "$output" == *"All 2 test files passed"* ]]
}

@test "fails when no test files are found" {
    run "$FAKE_REPO/bin/test.sh"
    [ "$status" -eq 1 ]
    [[ "$output" == *"no test files found"* ]]
}

@test "skips vendored libs and helpers" {
    write_test a_pass.bats true
    write_test libs/x.bats false
    write_test helpers/y.bats false

    run "$FAKE_REPO/bin/test.sh"
    [ "$status" -eq 0 ]
    [[ "$output" == *"All 1 test files passed"* ]]
}
