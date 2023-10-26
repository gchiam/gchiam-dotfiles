#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Zendesk VPN
# @raycast.mode compact
# @raycast.refreshTime 0s

# Optional parameters:
# @raycast.icon 🌐

# Documentation:
# @raycast.description Activate Zendesk VPN
# @raycast.author gchiam
# @raycast.authorURL https://raycast.com/gchiam


osascript /Users/gchiam/Code/zendesk/kubectl_config/bin/trigger_vpn_connection.applescript &

echo "Activating Zendesk VPN"
