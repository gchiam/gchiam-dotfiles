#!/bin/bash
set -euo pipefail

# Install GitHub CLI extensions
# Requires GitHub CLI to be installed and authenticated

# Verify gh is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed" >&2
    echo "Install with: brew install gh" >&2
    exit 1
fi

# Verify gh is authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: GitHub CLI is not authenticated" >&2
    echo "Run: gh auth login" >&2
    exit 1
fi

# List of extensions to install
extensions=(
    "dvlpr/gh-dash"
    "ghcli/gh-commit"
    "github/gh-copilot"
    "HaywardMorihara/gh-tidy"
    "hectcastro/gh-metrics"
)

echo "Installing GitHub CLI extensions..."

# Track success/failure
failed_extensions=()

for extension in "${extensions[@]}"; do
    echo -n "Checking $extension... "
    
    # Check if already installed
    if gh extension list | grep -q "$extension"; then
        echo "already installed ✓"
        continue
    fi
    
    # Install extension
    echo -n "installing... "
    if gh extension install "$extension" &> /dev/null; then
        echo "success ✓"
    else
        echo "failed ✗"
        failed_extensions+=("$extension")
    fi
done

# Report results
echo ""
if [[ ${#failed_extensions[@]} -eq 0 ]]; then
    echo "✓ All GitHub CLI extensions installed successfully"
else
    echo "✗ Failed to install ${#failed_extensions[@]} extension(s):"
    for ext in "${failed_extensions[@]}"; do
        echo "  - $ext"
    done
    exit 1
fi
