#!/bin/bash
set -euo pipefail

# Stow setup script for dotfiles
# Stows all configuration directories using GNU Stow

# Configuration
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
NON_INTERACTIVE=false

# Stow all configuration directories
stow_dir="$DOTFILES_DIR/stow"

# Print the physical path of a file: symlinks in its directory part are
# followed, the final component is kept as is. Works for dangling symlinks.
physical_path() {
    local dir
    dir=$(cd -P -- "$(dirname -- "$1")" 2>/dev/null && pwd -P) || return 1
    printf '%s/%s\n' "$dir" "$(basename -- "$1")"
}

# True when the target already points at the package file, either as a
# per-file symlink created by stow, or through a directory symlink created by
# stow's tree folding (e.g. ~/.config/nvim -> stow/nvim/.config/nvim).
is_managed_by_stow() {
    local target="$1"
    local source="$2"
    local expected link

    expected=$(physical_path "$source") || return 1

    if [[ "$(physical_path "$target")" == "$expected" ]]; then
        return 0
    fi

    if [[ -L "$target" ]]; then
        link=$(readlink "$target")
        [[ "$link" == /* ]] || link="$(dirname -- "$target")/$link"
        [[ "$(physical_path "$link")" == "$expected" ]] && return 0
    fi

    return 1
}

# True when the target's parent directory resolves inside the stow directory,
# i.e. the target is reached through a folded directory symlink. Moving or
# deleting such a path would modify the repository itself, so it must never be
# done by conflict resolution.
is_parent_inside_stow_dir() {
    local resolved_parent resolved_stow_dir
    resolved_parent=$(cd -P -- "$(dirname -- "$1")" 2>/dev/null && pwd -P) || return 1
    resolved_stow_dir=$(cd -P -- "$stow_dir" 2>/dev/null && pwd -P) || return 1
    [[ "$resolved_parent" == "$resolved_stow_dir" || "$resolved_parent" == "$resolved_stow_dir"/* ]]
}

resolve_conflict() {
    local target="$1"
    local source="$2"
    local choice=""

    if [[ "$NON_INTERACTIVE" == true ]]; then
        echo "Non-interactive mode: Skipping conflict at $target"
        return 1
    fi

    if is_parent_inside_stow_dir "$target"; then
        echo "Refusing to modify $target: it resolves inside the dotfiles repository" >&2
        return 1
    fi

    while true; do
        echo -n "Conflict at $target. [b]ackup, [d]iff, [o]verwrite, [s]kip? "
        if ! read -r choice; then
            echo
            echo "No input available: Skipping $target"
            return 1
        fi
        case "$choice" in
            b|backup)
                if [[ ! -w "$(dirname "$target")" ]]; then
                    echo "Error: No write permission for $(dirname "$target")" >&2
                    return 1
                fi
                echo "Backing up $target to ${target}.bak"
                mv "$target" "${target}.bak"
                return 0
                ;;
            d|diff)
                if command -v delta >/dev/null 2>&1; then
                    delta "$target" "$source"
                else
                    diff -u "$target" "$source" | less
                fi
                ;;
            o|overwrite)
                if [[ ! -w "$target" ]] && [[ -e "$target" ]]; then
                     if [[ ! -w "$(dirname "$target")" ]]; then
                        echo "Error: No write permission to delete $target" >&2
                        return 1
                     fi
                fi
                echo "Overwriting $target"
                rm -rf "$target"
                return 0
                ;;
            s|skip)
                echo "Skipping $target"
                return 1
                ;;
            *)
                echo "Invalid choice. Please enter b, d, o, or s."
                ;;
        esac
    done
}

check_stow_conflicts() {
    local pkg="$1"
    local pkg_dir="$stow_dir/$pkg"
    local skip_pkg=0

    if [[ ! -d "$pkg_dir" ]]; then
        return 0
    fi

    # Find all files in the package (relative to package root)
    local temp_files
    temp_files=$(mktemp)
    (cd "$pkg_dir" && find . -type f -o -type l) | sed 's|^\./||' > "$temp_files"

    while IFS= read -u 3 -r f; do
        local target="$HOME/$f"
        local source="$pkg_dir/$f"

        if [[ -e "$target" || -L "$target" ]] && ! is_managed_by_stow "$target" "$source"; then
            if ! resolve_conflict "$target" "$source"; then
                skip_pkg=1
                break
            fi
        fi
    done 3< "$temp_files"
    rm "$temp_files"

    if [[ $skip_pkg -eq 1 ]]; then
        return 1
    fi
    return 0
}

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --non-interactive)
                NON_INTERACTIVE=true
                shift
                ;;
            -h|--help)
                echo "Usage: $0 [--non-interactive]"
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                exit 1
                ;;
        esac
    done

    if [[ ! -d "$stow_dir" ]]; then
        echo "Error: Stow directory $stow_dir does not exist" >&2
        exit 1
    fi

    echo "Stowing configurations from $stow_dir..."
    cd "$stow_dir"

    for d in *; do
        [[ -d "$d" ]] || continue
        
        if ! check_stow_conflicts "$d"; then
            echo "Skipping $d due to conflicts"
            continue
        fi

        echo "Stowing $d..."
        if stow -v --dir="$stow_dir" --target="$HOME" --restow "$d"; then
            echo "✓ Successfully stowed $d"
        else
            echo "✗ Failed to stow $d" >&2
            # Continue with other directories instead of failing completely
        fi
    done

    cd - > /dev/null
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi