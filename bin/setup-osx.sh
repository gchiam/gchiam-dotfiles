#!/bin/bash


# install xcode
xcode-select --install

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew tap homebrew/cask
brew tap homebrew/cask-fonts

brew install zsh

brew install font-noto-sans font-noto-serif font-victor-mono font-victor-mono-nerd-font

brew install axel
brew install curl
brew install wget

brew install git
brew install tig
brew install the_silver_searcher
brew install tmux
brew install fzf

# install Python3
brew install python  # install Python 3
python -m ensurepip --upgrade
pip3 install -U pip




# development
# ~~~~~~~~~~~

brew install diff-so-fancy
brew install git-delta
# brew instal
brew install fx
brew install jq

brew install node.js


# install editors
brew install --HEAD neovim
brew install pyenv
brew install rbenv
brew install asdf

# install virtualbox & docker
brew install virtualbox virtualbox-extension-pack
brew install docker
brew install docker-machine
brew install docker-compose

# install android
brew install android-sdk android-platform-tools android-studio

brew install github

# http://facebook.github.io/PathPicker/
brew install fpp


# multimedia
# ~~~~~~~~~~

brew install imagemagick --with-librsvg
brew install gimp

# communications
# ~~~~~~~~~~~~~~

# install slack
brew install slack
brew install zoom


# system
# ~~~~~~
brew install 1password
brew install amethyst
brew install appcleaner
brew install dropbox
brew install flux
brew install flycut
brew install caffeine
brew install keycastr
brew install shortcat

brew install the-unarchiver

# osx fuse
brew install osxfuse
brew tap homebrew/fuse
brew install ntfs-3g
sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.original
sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs

# productivity
~~~~~~~~~~~~~~
brew install evernote
brew install remnote

# enjoy
brew install spotify


# https://gist.github.com/CFXd/9ddbba4607ceec5a2a2e
brew install fontforge ttf2eot ttfautohint


brew install adobe-creative-cloud
brew install adobe-creative-cloud-cleaner-tool

# SDKMan
curl -s "https://get.sdkman.io" | bash


# references:
# * https://gist.github.com/kevinelliott/0726211d17020a6abc1f
# * https://gist.github.com/kevinelliott/e12aa642a8388baf2499
# * http://www.codejuggle.dj/my-mac-os-x-development-setup/
# * https://blog.filippo.io/my-remote-shell-session-setup/
