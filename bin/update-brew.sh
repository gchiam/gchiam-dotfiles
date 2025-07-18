#!/bin/bash
set -euo pipefail

# Update and maintain Homebrew packages
# Performs update, upgrade, cleanup, and health check

echo "Starting Homebrew maintenance..."

# Verify Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed" >&2
    echo "Install from: https://brew.sh" >&2
    exit 1
fi

# Update Homebrew and formulae
echo "1. Updating Homebrew..."
if brew update; then
    echo "✓ Homebrew updated successfully"
else
    echo "✗ Failed to update Homebrew" >&2
    exit 1
fi

# Upgrade installed packages
echo ""
echo "2. Upgrading packages..."
if brew upgrade; then
    echo "✓ Packages upgraded successfully"
else
    echo "✗ Failed to upgrade packages" >&2
    exit 1
fi

# Cleanup old versions
echo ""
echo "3. Cleaning up old versions..."
if brew cleanup; then
    echo "✓ Cleanup completed successfully"
else
    echo "✗ Failed to cleanup" >&2
    # Don't exit on cleanup failure, continue with other operations
fi

# Cleanup cache
echo ""
echo "4. Cleaning up cache..."
if brew cleanup -s; then
    echo "✓ Cache cleanup completed successfully"
else
    echo "✗ Failed to cleanup cache" >&2
    # Don't exit on cache cleanup failure
fi

# Run diagnostics
echo ""
echo "5. Running diagnostics..."
if brew doctor; then
    echo "✓ All diagnostics passed"
else
    echo "⚠ Some diagnostics failed (this may be normal)"
    # Don't exit on doctor warnings, they're often informational
fi

echo ""
echo "✓ Homebrew maintenance completed successfully!"

# Show summary of installed packages
echo ""
echo "Summary:"
echo "  Formulae: $(brew list --formula | wc -l | tr -d ' ')"
echo "  Casks: $(brew list --cask | wc -l | tr -d ' ')"
