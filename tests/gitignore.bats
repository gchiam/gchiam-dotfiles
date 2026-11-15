#!/usr/bin/env bats

# A file must not be both tracked and gitignored: either the ignore rule is
# wrong or the file should not be committed.

@test "no tracked file matches a .gitignore rule" {
    run git ls-files --cached --ignored --exclude-standard
    [ "$status" -eq 0 ]
    if [ -n "$output" ]; then
        echo "Tracked but ignored:" >&2
        echo "$output" >&2
        return 1
    fi
}
