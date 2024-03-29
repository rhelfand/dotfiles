#!/usr/bin/env bash


## This script is used to bootstrap Brew and setup
## my environment on a Mac or Linux host.
## I assume you're in $HOME/dotfiles to begin.


## What's my OS?
if [[ "$OSTYPE" =~ "linux" ]] ; then
  # We're a Linux host!  I'll just install GNU Stow locally
  if [[ ! -x "$(command -v stow)" ]] ; then
    stowversion="2.3.1"
    [[ -d "$HOME/local" ]] || mkdir "$HOME/local"
    curl -O http://ftp.gnu.org/gnu/stow/stow-${stowversion}.tar.gz
    tar xzf stow-${stowversion}.tar.gz
    cd stow-${stowversion} || exit 1
    ./configure --prefix="$HOME"/local && make && make install && PATH=$PATH:$HOME/local/bin
    cd ..
  fi

elif [[ "$OSTYPE" =~ "darwin" ]]; then
  # We're on a Mac!  I'm assuming this is *my* mac and I can install what I want
  # First, install brew!
  [[ -x "$(command -v brew)" ]] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  # Add Homebrew to $PATH and set useful env vars
  if command -v /opt/homebrew/bin/brew &> /dev/null; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif command -v /usr/local/bin/brew &> /dev/null; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    HOMEBREW_PREFIX=""
  fi

  # Make sure we’re using the latest Homebrew.
  brew update

  # Upgrade any already-installed formulae.
  brew upgrade

  # Install my applications and casks
  brew bundle

  # Use the newly installed version of bash
  if ! grep -Fq "$HOMEBREW_PREFIX/bin/bash" /etc/shells; then
    echo "$HOMEBREW_PREFIX/bin/bash" | sudo tee -a /etc/shells;
    chsh -s "$HOMEBREW_PREFIX/bin/bash";
  fi;

  # Set a couple of defaults via CLI
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10
  defaults write com.googlecode.iterm2 PinchToChangeFontSizeDisabled -bool true
  defaults write com.apple.dock showhidden -bool true
  defaults write com.apple.finder AppleShowAllFiles YES
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true


else
  echo "Error:  Can't determine OS.  Exiting."
  exit 1

fi

## Trying to make this idempotently stow my files
STOWPKGS="bash bc vim git"

[[ -d "$HOME/origdotfiles" ]] || mkdir "$HOME/origdotfiles"
for STOWPKG in $STOWPKGS ; do
  echo "Using stow to manage dotfiles for $STOWPKG ..."
  # If stow errors out, a file or link already exists
  if ! stow "$STOWPKG" > /dev/null 2>&1 ; then
    echo "Warning: Something in $STOWPKG is conflicting with stow.  Trying to fix ..."
    for ORIG_FILE in "$PWD"/"$STOWPKG"/.[a-z]* ; do
      i=$(basename "$ORIG_FILE")
      [[ -f "$HOME"/"$i" ]] && mv "$HOME"/"$i" "$HOME"/origdotfiles/"$i"."$(date '+%Y%m%d%H%M%S')"
    done
    # Now try it again.  This is ugly I know.
    if ! stow "$STOWPKG" ; then
      echo "Error: stow is unable to install $STOWPKG"
      exit 1
    fi
  fi
done

## The vim plugins from my .vimrc use Vundle for management, so let's install
if [[ ! -r "$HOME/.vim/bundle/Vundle.vim" ]] ; then
  git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
  echo "Launch vim and run ':PluginInstall' to configure Vim plugins."
else
  echo "Warning:  Vundle is already installed.  Skipping."
fi
