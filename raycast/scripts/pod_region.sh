#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Z PoD region
# @raycast.mode compact
# @raycast.refreshTime 0s

# Optional parameters:
# @raycast.icon 🌏
# @raycast.argument1 { "type": "text", "placeholder": "pod" }

# Documentation:
# @raycast.description Lookup Z PoD region
# @raycast.author gchiam
# @raycast.authorURL https://raycast.com/gchiam

# shellcheck disable=SC1090  # Dynamic sourcing for environment variables
source ~/.bash_local
pod=${1}
key="${pod}.AWS_REGION"
region=$(curl -s https://gchiam:"$GITHUB_TOKEN"@raw.githubusercontent.com/zendesk/config-service-data/master/data/shared_env_groups/aws_region.json | jq -r ".$key")

echo -e "🌏 $pod region: $region"
