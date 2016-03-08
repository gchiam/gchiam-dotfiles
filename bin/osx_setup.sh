#!/bin/bash


# install xcode
xcode-select --install

# install homebrew
ruby -e “$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)”
brew doctor
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew install axel
brew install curl
brew install git
brew install --HEAD mobile-shell
brew install the_silver_searcher
brew install tmux --HEAD
brew install wget

# install python2 & python3
brew install python
brew install python3
pushd /tmp
curl -O http://python-distribute.org/distribute_setup.py
python distribute_setup.py
python3 distribute_setup.py
curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py
python3 get-pip.py
pip install -U pip
pip3 install -U pip
popd


# mosh
brew install --HEAD mobile-shell



# development
# ~~~~~~~~~~~

brew cask install --HEAD iterm2-beta

# install node.js and npm
brew instal1l node.js

# install NyaoVim: GUI frontend of NeoVim
npm install -g nyaovim

# install editors
brew cask install atom
brew cask install brackets

# install virtualbox
brew cask install virtualbox
brew cask install virtualbox-extension-pack

# install anvil
brew cask install anvil  # manage local website

# install android
brew install android-sdk
brew cask install android-studio

brew cask install github


# communications
# ~~~~~~~~~~~~~~

# install slack
brew cask install slack


# system
# ~~~~~~
brew cask install appcleaner
brew cask install battery-guardian
brew cask install dropbox
brew cask install mattr-slate
brew cask install the-unarchiver

# productivity
~~~~~~~~~~~~~~
brew cask install evernote
brew cask install gimp

# enjoy
brew cask install awareness
brew cask install spotify


# references:
# * https://gist.github.com/kevinelliott/0726211d17020a6abc1f
# * https://gist.github.com/kevinelliott/e12aa642a8388baf2499
# * http://www.codejuggle.dj/my-mac-os-x-development-setup/
# * https://blog.filippo.io/my-remote-shell-session-setup/
