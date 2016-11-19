#!/bin/bash


# install xcode
xcode-select --install

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew install ruby

brew install axel
brew install curl
brew install wget

brew install git
brew install --HEAD mobile-shell
brew install the_silver_searcher
brew install ripgrep
brew install tmux  # --HEAD
brew install fzf

brew tap jhawthorn/fzy
brew install fzy

/usr/local/bin/gem install tmuxinator
/usr/local/bin/gem install grepg

# install python2 & python3
brew install python
brew install python3
pushd /tmp
curl -O http://python-distribute.org/distribute_setup.py
python distribute_setup.py
python3 distribute_setup.py
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
python3 get-pip.py
pip install -U pip
pip3 install -U pip
brew install pkg-config
popd


# mosh
brew install --HEAD mobile-shell



# development
# ~~~~~~~~~~~

brew cask install iterm2
brew install diff-so-fancy
brew install ctags

# install node.js and npm
brew install node.js

# install NyaoVim: GUI frontend of NeoVim
npm install -g nyaovim

# install editors
brew cask install atom
brew cask install brackets

# install virtualbox & docker
brew cask install virtualbox
brew cask install virtualbox-extension-pack
brew install docker
brew install docker-machine
brew install docker-compose

# install anvil
brew cask install anvil  # manage local website

# install android
brew install android-sdk
brew cask install android-studio

brew cask install github-desktop

# http://facebook.github.io/PathPicker/
brew install fpp


# multimedia
# ~~~~~~~~~~

brew cask install vlc
brew install imagemagick --with-librsvg
brew cask install gimp

# communications
# ~~~~~~~~~~~~~~

# install slack
brew cask install slack


# system
# ~~~~~~
brew cask install 1password
brew cask install appcleaner
brew cask install battery-guardian
brew cask install dropbox
brew cask install flux
brew cask install keepingyouawake
brew cask install keycastr
brew cask install mattr-slate
brew cask install shortcat

brew cask install the-unarchiver

# osx fuse
brew cask install osxfuse
brew tap homebrew/fuse
brew install ntfs-3g
sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.original
sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs

# productivity
~~~~~~~~~~~~~~
brew cask install evernote
brew cask install gimp

# enjoy
brew cask install awareness
brew cask install spotify


# https://gist.github.com/CFXd/9ddbba4607ceec5a2a2e
brew install fontforge ttf2eot ttfautohint


brew cask install adobe-creative-cloud
brew cask install adobe-creative-cloud-cleaner-tool


# references:
# * https://gist.github.com/kevinelliott/0726211d17020a6abc1f
# * https://gist.github.com/kevinelliott/e12aa642a8388baf2499
# * http://www.codejuggle.dj/my-mac-os-x-development-setup/
# * https://blog.filippo.io/my-remote-shell-session-setup/
