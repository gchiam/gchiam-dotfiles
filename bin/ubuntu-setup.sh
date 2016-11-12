#!/bin/bash


sudo apt-get update
sudo apt-get dist-upgrade -y

sudo apt-get install -y openssh-server
sudo apt-get install -y git
sudo apt-get install -y build-essential
sudo apt-get install -y python-dev python3-dev
sudo apt-get install -u libtool libtool-bin autoconf automake cmake g++ pkg-config unzip gperf


sudo apt-get install -y ruby
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"
export PATH="~/.linuxbrew/bin:$PATH"
brew doctor

brew install perl
brew install git

# install python2 & python3
brew install python
brew install python3
pushd /tmp
curl -O https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py
sudo pip install --user -U pip
sudo pip3 install --user -U pip
popd

brew install golang
brew install tig
brew install the_silver_searcher
brew install tmux --HEAD
brew install node.js
brew install docker
brew install docker-machine
brew install docker-compose

brew tap neovim/neovim
brew install --HEAD --with-release neovim

brew install fpp
brew install fzf
brew install diff-so-fancy

brew install cowsay
brew install fortune

cd $HOME
mkdir -p projects
cd projects

git clone --recursive --jobs=4 git@github.com:gchiam/gchiam-dotfiles.git
cd gchiam-dotfiles
bin/setup.sh
sudo pip install --user -r pip-requirements/dev.txt
