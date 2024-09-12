#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
ln -snvf "$HOME/projects/gchiam-dotfiles" "$DOTFILES_DIR"

# Run stow
stow_dir=${DOTFILES_DIR}/stow
if ! command -v stow &> /dev/null
then
    echo "stow could not be found. Will not brew install stow."
    brew install stow
fi

cd "$stow_dir" || exit
for d in *; do
  [[ -d $d ]] || continue
  echo "stowing $d..."
  command stow -v --dir="${stow_dir}" --target="$HOME" --restow "$d"
done
cd - || exit
[ "${commands[bat]}" ] && command bat cache --build

# generate ~/fleet.properties
echo "fleet.config.path=${HOME}/.config/JetBrains/Fleet/" > ~/fleet.properties

[ -d "$HOME/.fzf" ] || mkdir "$HOME/.fzf"
[ -f "$HOME/.fzf.zsh" ] && ln -snvf "$HOME/.fzf.zsh" "$HOME/.fzf/fzf.zsh"
