#!/bin/bash

extensions=(
  "dvlpr/gh-dash"
  "hectcastro/gh-metrics"
)

for extension in "${extensions[@]}"; do
  gh extension install "$extension"
done
