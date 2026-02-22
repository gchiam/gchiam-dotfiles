#!/bin/bash
set -euo pipefail

# Stow setup script for dotfiles
# Stows all configuration directories using GNU Stow

# Configuration
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
NON_INTERACTIVE=false

# Stow all configuration directories
stow_dir="$DOTFILES_DIR/stow"

resolve_conflict() {
    local target="$1"
    local source="$2"
    local choice=""

    if [[ "$NON_INTERACTIVE" == true ]]; then
        echo "Non-interactive mode: Skipping conflict at $target"
        return 1
    fi

    while true; do
        echo -n "Conflict at $target. [b]ackup, [d]iff, [o]verwrite, [s]kip? "
        read -r choice
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
        
        if [[ -e "$target" || -L "$target" ]]; then
            local is_conflict=0
            
            # If it's a symlink, check where it points
            if [[ -L "$target" ]]; then
                local link_target
                link_target=$(readlink "$target")
                
                # Get absolute paths for comparison
                local abs_link_target
                abs_link_target=$(python3 -c "import os; print(os.path.abspath(os.path.join(os.path.dirname('$target'), '$link_target')))")
                local abs_pkg_file
                abs_pkg_file=$(python3 -c "import os; print(os.path.abspath('$source'))")

                if [[ "$abs_link_target" != "$abs_pkg_file" ]]; then
                    is_conflict=1
                fi
            else
                # It's a regular file or directory
                is_conflict=1
            fi

            if [[ $is_conflict -eq 1 ]]; then
                if ! resolve_conflict "$target" "$source"; then
                    skip_pkg=1
                    break
                fi
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