#!/bin/bash

# Join all arguments into a comma-separated list
AGENTS=$(echo "$*" | tr ' ' ',')

# Check if agents were provided
if [ -z "$AGENTS" ]; then
  echo "Usage: $0 <agents...> (e.g., claude-code, gemini-cli)"
  echo "See complete list of agents: https://github.com/vercel-labs/skills#supported-agents"
  exit 1
fi

SKILLS_FILE="$HOME/.agents/.skill-lock.json"

# Validate skills file existence
if [ ! -f "$SKILLS_FILE" ]; then
  echo "Error: $SKILLS_FILE not found."
  exit 1
fi

# Extract skill name and source using jq and iterate
jq -r '.skills | to_entries[] | "\(.key) \(.value.source)"' "$SKILLS_FILE" | while read -r skill source; do
  echo "Syncing skill: $skill ($source) to agents: $AGENTS"
  npx skills add "$source" --skill "$skill" -g -a "$AGENTS" -y
done
