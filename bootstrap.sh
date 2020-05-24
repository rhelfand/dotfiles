#!/usr/bin/env bash


## This script is used to bootstrap Brew and setup
## my environment on a Mac or Linux host.


## What's my OS?
if [[ "$OSTYPE" =~ "linux" ]] ; then
  # TODO apt vs rpm?
  # Install some packages
  [[ -x "$(command -v stow)" ]] || sudo apt install stow

elif [[ "$OSTYPE" =~ "darwin" ]]; then
  # First, install brew!
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Make sure we’re using the latest Homebrew.
  brew update

  # Upgrade any already-installed formulae.
  brew upgrade

  # Install my applications and casks
  brew bundle

fi

# Now, use stow to install dotfiles
# Move orig files out of the way first (this is kind of ugly)
[[ -d "$HOME/origdotfiles" ]] || mkdir $HOME/origdotfiles
for ORIG_FILE in .bash_profile .bashrc .vimrc .bcrc .gitconfig .gitignore_global ; do
  if [[ -r "$HOME/$ORIG_FILE" ]] ; then
    mv $HOME/$ORIG_FILE $HOME/origdotfiles/${ORIG_FILE}.`date '+%Y%m%d%H%M%S'`
  fi
done

stow bash
stow bc
stow vim
stow git

# Setup vim plugins.  First install Vundle:
[[ -r "$HOME/.vim/bundle/Vundle.vim" ]] || git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
echo "Launch vim and run ':PluginInstall' to configure Vim plugins."
echo ""
