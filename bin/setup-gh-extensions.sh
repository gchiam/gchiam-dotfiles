#!/bin/bash

extensions=(
  "dvlpr/gh-dash"
  "HaywardMorihara/gh-tidy"
  "hectcastro/gh-metrics"
)

for extension in "${extensions[@]}"; do
  gh extension install "$extension"
done
