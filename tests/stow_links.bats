#!/usr/bin/env bats

# Every symlink inside a stow package must point at something that exists,
# unless it points into a git submodule (those are only populated after
# `git submodule update --init`).

submodule_paths() {
    git config --file .gitmodules --get-regexp '^submodule\..*\.path$' | awk '{print $2}'
}

@test "stow packages contain no dangling symlinks outside submodules" {
    local repo_root submodules link target rel dangling=()
    repo_root="$(pwd -P)"
    submodules="$(submodule_paths)"

    while IFS= read -r link; do
        [[ -e "$link" ]] && continue
        target="$(readlink "$link")"
        [[ "$target" == /* ]] || target="$(dirname "$link")/$target"
        # Normalise ../ segments textually (the target does not exist)
        rel="$(python3 -c 'import os,sys; print(os.path.relpath(os.path.normpath(sys.argv[1]), sys.argv[2]))' "$target" "$repo_root")"
        while IFS= read -r sub; do
            [[ -n "$sub" && "$rel" == "$sub"/* ]] && continue 2
        done <<< "$submodules"
        dangling+=("$link -> $(readlink "$link")")
    done < <(find "$repo_root/stow" -type l)

    if (( ${#dangling[@]} )); then
        printf 'Dangling symlink: %s\n' "${dangling[@]}" >&2
        return 1
    fi
}
