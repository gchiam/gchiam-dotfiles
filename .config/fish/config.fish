#set fish_function_path $fish_function_path "$HOME/dotfiles/external/powerline/powerline/bindings/fish"
#powerline-setup
# Path to your oh-my-fish.
#
# set fish_path $HOME/.oh-my-fish

# Path to your custom folder (default path is ~/.oh-my-fish/custom)
#set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
# . $fish_path/oh-my-fish.fish

# Custom plugins and themes may be added to ~/.oh-my-fish/custom
# Plugins and themes can be found at https://github.com/oh-my-fish/
# Theme 'robbyrussell'
# Plugin 'theme'
#

# load aliases
. ~/.config/fish/prompt.fish
. ~/.config/fish/aliases.fish
. ~/.config/fish/extras.fish
# BEGIN ZDI
set -x AWS_ENABLED true
set -x DOCKER_IMAGES_DEBUG true
set -x DOCKER_HOST_IP 13.229.138.222
source /Users/gchiam/Code/zendesk/zdi/dockmaster/zdi.fish
# END ZDI
