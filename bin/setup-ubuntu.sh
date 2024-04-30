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

cd $HOME
mkdir -p projects
cd projects

git clone --recursive --jobs=4 git@github.com:gchiam/gchiam-dotfiles.git
cd gchiam-dotfiles
bin/setup.sh
sudo pip install --user -r pip-requirements/dev.txt
