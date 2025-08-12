#!/bin/bash
set -euo pipefail

# Updates all git submodules to their latest commits
# Requires being run from within a git repository with submodules

echo "Updating git submodules..."

# Verify we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository" >&2
    exit 1
fi

# Check if repository has submodules
if [[ ! -f .gitmodules ]]; then
    echo "No .gitmodules file found - this repository has no submodules"
    exit 0
fi

# Initialize submodules if needed
echo "Initializing submodules..."
if git submodule init; then
    echo "✓ Submodules initialized"
else
    echo "✗ Failed to initialize submodules" >&2
    exit 1
fi

# Update submodules
echo "Updating submodules..."
# shellcheck disable=SC2034  # Variable reserved for future use
failed_submodules=()

# Use --recursive flag and capture failures
if git submodule update --recursive --remote; then
    echo "✓ All submodules updated successfully"
else
    echo "⚠ Some submodules may have failed to update"
fi

# Alternative approach: update each submodule individually for better error reporting
echo "Pulling latest changes for each submodule..."
git submodule foreach --recursive '
    echo "Updating submodule: $displaypath"
    if git pull; then
        echo "✓ Successfully updated $displaypath"
    else
        echo "✗ Failed to update $displaypath" >&2
    fi
'

echo ""
echo "✓ Submodule update process completed"
echo "Run 'git status' to see any changes that need to be committed"
