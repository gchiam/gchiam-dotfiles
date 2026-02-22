#!/bin/bash
set -euo pipefail

# Theme Orchestrator for My Dotfiles
# Centralizes and automates system-wide theme switching (Dark/Light mode)

PREFS_FILE="$HOME/Library/Preferences/.GlobalPreferences.plist"
STATE_FILE="${CATPPUCCIN_STATE_FILE:-/tmp/catppuccin_flavor}"

get_system_theme() {
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
        echo "Dark"
    else
        echo "Light"
    fi
}

get_catppuccin_flavor() {
    local theme
    theme=$(get_system_theme)
    if [[ "$theme" == "Dark" ]]; then
        echo "frappe"
    else
        echo "latte"
    fi
}

broadcast_theme() {
    local flavor=$1
    echo "Broadcasting flavor: $flavor"
    echo "$flavor" > "$STATE_FILE"
}

# Handle command line arguments
case "${1:-}" in
    --get)
        get_system_theme
        exit 0
        ;;
    --flavor)
        get_catppuccin_flavor
        exit 0
        ;;
    --watch)
        # Watch mode implemented below
        ;;
    *)
        # Default behavior: Print current status and exit if no args
        if [[ $# -eq 0 ]]; then
            echo "Current Theme: $(get_system_theme)"
            echo "Catppuccin Flavor: $(get_catppuccin_flavor)"
            exit 0
        fi
        ;;
esac

# Watch mode requires fswatch
if ! command -v fswatch >/dev/null; then
    echo "Error: fswatch not found. Install with: brew install fswatch" >&2
    exit 1
fi

echo "Starting Unified Theme Orchestrator..."
echo "Monitoring $PREFS_FILE for appearance changes..."

# Handle initial state
CURRENT_FLAVOR=$(get_catppuccin_flavor)
broadcast_theme "$CURRENT_FLAVOR"

# Watch for changes
fswatch -o "$PREFS_FILE" | while read -r _; do
    NEW_FLAVOR=$(get_catppuccin_flavor)
    if [[ "$NEW_FLAVOR" != "$CURRENT_FLAVOR" ]]; then
        echo "$(date): Theme changed to $NEW_FLAVOR"
        broadcast_theme "$NEW_FLAVOR"
        CURRENT_FLAVOR="$NEW_FLAVOR"
    fi
done
