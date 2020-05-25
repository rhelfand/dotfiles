#!/usr/bin/env bash


## This script is used to bootstrap Brew and setup
## my environment on a Mac or Linux host.


# What's my OS?
if [[ "$OSTYPE" =~ "linux" ]] ; then
  # We're a Linux host!
  # TODO apt vs rpm?
  # Install some packages
  [[ -x "$(command -v stow)" ]] || sudo apt install stow

elif [[ "$OSTYPE" =~ "darwin" ]]; then
  # We're on a Mac!
  # First, install brew!
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Make sure we’re using the latest Homebrew.
  brew update

  # Upgrade any already-installed formulae.
  brew upgrade

  # Install my applications and casks
  brew bundle

else
  echo "Error:  Can't determine OS.  Exiting."
  exit 1

fi

# Trying to make this idempotently stow my files
STOWPKGS="bash bc vim git"

[[ -d "$HOME/origdotfiles" ]] || mkdir "$HOME/origdotfiles"
for STOWPKG in $STOWPKGS ; do
  echo "Using stow to manage dotfiles for $STOWPKG ..."
  # If stow errors out, a file or link already exists
  if ! stow "$STOWPKG" > /dev/null 2>&1 ; then
    echo "Warning: Something in $STOWPKG is conflicting with stow.  Trying to fix ..."
    for ORIG_FILE in $(ls -A "$(pwd)"/"$STOWPKG") ; do
      mv "$HOME/$ORIG_FILE" "$HOME/origdotfiles/${ORIG_FILE}.$(date '+%Y%m%d%H%M%S')"
    done
    # Now try it again.  This is ugly I know.
    if ! stow "$STOWPKG" ; then
      echo "Error: stow is unable to install $STOWPKG"
      exit 1
    fi
  fi
done

# Setup vim plugins.  First install Vundle:
[[ -r "$HOME/.vim/bundle/Vundle.vim" ]] || git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
echo "Launch vim and run ':PluginInstall' to configure Vim plugins."
echo ""
