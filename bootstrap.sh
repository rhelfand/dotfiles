#!/usr/bin/env bash

## This script is used to bootstrap Brew and setup
## my environment on a Mac.

# First, install brew!
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install my applications and casks
brew bundle

# Use stow to install dotfiles
mv ~/.bash_profile ~/.bash_profile.ORIG
mv ~/.bashrc ~/.bashrc.ORIG
stow bash
stow bc
