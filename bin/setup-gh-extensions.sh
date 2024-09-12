#!/bin/bash

extensions=(
  "dvlpr/gh-dash"
)

for extension in "${extensions[@]}"; do
  gh extension install "$extension"
done
