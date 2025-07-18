#!/bin/bash
set -euo pipefail

# Add GitHub SSH configuration to ~/.ssh/config safely
# Usage: ./add-github-to-ssh-config.sh [email]

EMAIL="${1:-${GIT_EMAIL:-$(git config --global user.email 2>/dev/null || echo "gordon.chiam@gmail.com")}}"
SSH_CONFIG="$HOME/.ssh/config"

# Create SSH directory if it doesn't exist
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Create or fix permissions on config file
if [[ ! -f "$SSH_CONFIG" ]]; then
    touch "$SSH_CONFIG"
    chmod 600 "$SSH_CONFIG"
elif [[ $(stat -f "%A" "$SSH_CONFIG" 2>/dev/null || stat -c "%a" "$SSH_CONFIG" 2>/dev/null) != "600" ]]; then
    chmod 600 "$SSH_CONFIG"
fi

# Check if GitHub config already exists
if grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
    echo "GitHub SSH configuration already exists in $SSH_CONFIG"
    exit 0
fi

# Add GitHub configuration safely by appending
echo "Adding GitHub SSH configuration for $EMAIL..."
{
    echo ""
    echo "Host github.com"
    echo "    HostName ssh.github.com"
    echo "    IdentityFile ~/.ssh/$EMAIL"
    echo ""
} >> "$SSH_CONFIG"

echo "✓ GitHub SSH configuration added successfully to $SSH_CONFIG"