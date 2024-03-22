#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Z VPN
# @raycast.mode compact
# @raycast.refreshTime 0s

# Optional parameters:
# @raycast.icon 🌐

# Documentation:
# @raycast.description Activate Z VPN
# @raycast.author gchiam
# @raycast.authorURL https://raycast.com/gchiam


osascript /Users/gchiam/Code/zendesk/kubectl_config/bin/trigger_vpn_connection.applescript &

echo "Activating Z VPN"
