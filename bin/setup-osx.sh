#!/bin/bash


# install xcode
xcode-select --install

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

# osx fuse
# sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.original
# sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs

# SDKMan
curl -s "https://get.sdkman.io" | bash


# references:
# * https://gist.github.com/kevinelliott/0726211d17020a6abc1f
# * https://gist.github.com/kevinelliott/e12aa642a8388baf2499
# * http://www.codejuggle.dj/my-mac-os-x-development-setup/
# * https://blog.filippo.io/my-remote-shell-session-setup/
