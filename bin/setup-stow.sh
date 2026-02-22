#!/bin/bash
set -euo pipefail

# Stow setup script for dotfiles
# Stows all configuration directories using GNU Stow

# Configuration
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Stow all configuration directories
stow_dir="$DOTFILES_DIR/stow"

check_stow_conflicts() {
    local pkg="$1"
    local pkg_dir="$stow_dir/$pkg"
    local conflict_found=0

    if [[ ! -d "$pkg_dir" ]]; then
        return 0
    fi

    # Find all files in the package (relative to package root)
    # We use a temporary file to handle filenames with spaces
    local temp_files
    temp_files=$(mktemp)
    (cd "$pkg_dir" && find . -type f -o -type l) | sed 's|^\./||' > "$temp_files"

    while IFS= read -r f; do
        local target="$HOME/$f"
        if [[ -e "$target" || -L "$target" ]]; then
            # If it's a symlink, check where it points
            if [[ -L "$target" ]]; then
                local link_target
                link_target=$(readlink "$target")
                
                # Get absolute paths for comparison
                local abs_link_target
                abs_link_target=$(python3 -c "import os; print(os.path.abspath(os.path.join(os.path.dirname('$target'), '$link_target')))")
                local abs_pkg_file
                abs_pkg_file=$(python3 -c "import os; print(os.path.abspath('$pkg_dir/$f'))")

                if [[ "$abs_link_target" != "$abs_pkg_file" ]]; then
                    echo "Conflict detected: $target is a symlink pointing to $link_target"
                    conflict_found=1
                fi
            else
                # It's a regular file or directory
                echo "Conflict detected: $target exists and is not a symlink"
                conflict_found=1
            fi
        fi
    done < "$temp_files"
    rm "$temp_files"

    if [[ $conflict_found -eq 1 ]]; then
        return 1
    fi
    return 0
}

main() {
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