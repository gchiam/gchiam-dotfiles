#!/usr/bin/env bats

# Submodules must be clonable without SSH keys (CI runners, fresh machines).

@test "all submodule URLs use HTTPS" {
    run git config --file .gitmodules --get-regexp '^submodule\..*\.url$'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 0 ]
    for line in "${lines[@]}"; do
        url="${line#* }"
        [[ "$url" == https://* ]] || {
            echo "Non-HTTPS submodule URL: $line" >&2
            return 1
        }
    done
}
