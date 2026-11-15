#!/usr/bin/env bats

# Keep documentation in sync with the repository layout.

@test "README stow examples only name existing stow packages" {
    run grep -oE '^stow -d stow -t ~ [A-Za-z0-9_-]+' README.md
    [ "$status" -eq 0 ]
    for line in "${lines[@]}"; do
        pkg="${line##* }"
        [ -d "stow/$pkg" ] || {
            echo "README references missing stow package: $pkg" >&2
            return 1
        }
    done
}
