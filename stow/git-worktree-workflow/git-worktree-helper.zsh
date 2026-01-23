# vim: set ft=zsh:
# shellcheck shell=bash
# Git Worktree Helper Functions
# Provides helper functions for managing git worktrees in bare-clone projects.

function gwt-add() {
    if [[ ! -d ".bare" ]]; then
        echo "❌ Error: Not in a bare-worktree project root."
        return 1
    fi
    
    local BRANCH=$1
    if [[ -z "$BRANCH" ]]; then
        echo "Usage: gwt-add <branch-name>"
        return 1
    fi

    # Sanitize folder name
    local FOLDER_NAME="${BRANCH//[\/\\]/_}"

    echo "🔍 Checking for branch: $BRANCH..."

    # Check if branch exists locally or on remote
    # ls-remote checks the server; rev-parse checks local cache
    if git rev-parse --verify "$BRANCH" >/dev/null 2>&1 || \
       git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
        
        echo "🌿 Branch '$BRANCH' found. Tracking..."
        # Fetch first to ensure the bare repo has the objects for this branch
        git fetch origin "$BRANCH"
        git worktree add "$FOLDER_NAME" "$BRANCH"
    else
        echo "✨ Branch '$BRANCH' not found. Creating new..."
        git worktree add -b "$BRANCH" "$FOLDER_NAME"
    fi
}
