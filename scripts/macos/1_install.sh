#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Making directories..."
mkdir -p ~/workspace
mkdir -p ~/dev
mkdir -p ~/.ssh/work
mkdir -p ~/.ssh/personal
mkdir ~/.nvm

###############################################################################
# Install applications                                                        #
###############################################################################

echo "Installing homebrew..."
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

echo 'Checking to see if XCode Command Line Tools are installed...'
brew config

echo "Updating Homebrew..."
brew update

echo "Upgrading Homebrew..."
brew upgrade

echo "Adding taps ..."
brew tap homebrew/cask-drivers

echo "Installing tools..."
brew install bash-completion
brew install bat
brew install coreutils
brew install deno
brew install ffmpeg
brew install gh
brew install git
brew install go
brew install htop
brew install httpie
brew install jq
brew install mysql
brew install neofetch
brew install nmap
brew install nvm
brew install postgresql
brew install prettyping
brew install rbenv
brew install rcm
brew install readline
brew install trash
brew install tree
brew install watch
brew install wget
brew install youtube-dl
brew install --cask charles
brew install --cask chromium
brew install --cask coconutbattery
brew install --cask cyberduck
brew install --cask discord
brew install --cask docker
brew install --cask finicky
brew install --cask gimp
brew install --cask iterm2
brew install --cask licecap
brew install --cask little-snitch
brew install --cask micro-snitch
brew install --cask mysides
brew install --cask obs
brew install --cask openvpn-connect
brew install --cask platypus
brew install --cask qmk-toolbox
brew install --cask signal
brew install --cask spectacle
brew install --cask transmission
brew install --cask telegram
brew install --cask tunnelblick
brew install --cask visual-studio-code
brew install --cask vlc
brew install --cask --appdir="/Applications" brave-browser
brew install --cask --appdir="/Applications" firefox

echo "Running brew cleanup..."
brew cleanup
brew cask cleanup

echo "Adding favorites to Finder"
mysides add Home file:///Users/tt
mysides add workspace file:///Users/tt/workspace
mysides add dev file:///Users/tt/dev
mysides add Documents file:///Users/tt/Documents
mysides add Downloads file:///Users/tt/Downloads
mysides add Pictures file:///Users/tt/Pictures

echo "Installing bash-it..."
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
./.bash_it/install.sh

echo "Installing node..."
nvm install node
npm install -g yarn firebase-tools parcel-bundler git-branch-select

echo "Done! Now create an SSH key and clone repos"
echo "newkey script, ssh-add, find repos script"
