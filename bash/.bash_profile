PATH=${PATH}:~/scripts
PATH=${PATH}:/usr/local/opt/node@6/bin

# include pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PATH

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
