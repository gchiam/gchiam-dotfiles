#!/bin/bash
set -euo pipefail

# Setup tmux terminal information
#
# Installs custom terminfo entries for tmux that enable proper italics
# and other advanced terminal features in tmux sessions.
#
# Requires: tic command (from ncurses package)

echo "Setting up tmux terminal information..."

# Verify tic command exists
if ! command -v tic &> /dev/null; then
    echo "Error: tic command not found" >&2
    echo "Please install ncurses development tools:" >&2
    echo "  macOS: already included with system" >&2
    echo "  Ubuntu/Debian: apt install ncurses-bin" >&2
    echo "  RHEL/CentOS: yum install ncurses" >&2
    exit 1
fi

# Create temporary file for terminfo definition
terminfo_file=$(mktemp)
trap 'rm -f "$terminfo_file"' EXIT

# Write terminfo definition
cat > "$terminfo_file" << 'EOF'
tmux|tmux terminal multiplexer,
  ritm=\E[23m, rmso=\E[27m, sitm=\E[3m, smso=\E[7m, Ms@,
  use=xterm+tmux, use=screen,

tmux-256color|tmux with 256 colors,
  use=xterm+256setaf, use=tmux,
EOF

# Install terminfo entries
echo "Installing tmux terminfo entries..."
if tic -x "$terminfo_file"; then
    echo "✓ tmux terminal information installed successfully"
    echo ""
    echo "You can now use these terminal types in tmux:"
    echo "  set-option -g default-terminal 'tmux-256color'"
    echo "  set-option -g default-terminal 'tmux'"
else
    echo "✗ Failed to install tmux terminal information" >&2
    exit 1
fi

# Verify installation
echo ""
echo "Verifying installation..."
if infocmp tmux >/dev/null 2>&1 && infocmp tmux-256color >/dev/null 2>&1; then
    echo "✓ Both tmux terminal types are now available"
else
    echo "⚠ Installation may have issues - check with 'infocmp tmux'" >&2
fi