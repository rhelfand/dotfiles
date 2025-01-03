# User specific aliases and functions

## Function to nicely append or prepend PATH.  I stole this from google
pathmunge () {
        if ! echo "$PATH" | grep -Eq "(^|:)$1($|:)" ; then
           if [ "$2" = "after" ] ; then
              PATH="$PATH:$1"
           else
              PATH="$1:$PATH"
           fi
        fi
}

# Add Homebrew to $PATH and set useful env vars
if command -v /opt/homebrew/bin/brew &> /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif command -v /usr/local/bin/brew &> /dev/null; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  HOMEBREW_PREFIX=""
fi


## Other PATH things I use
pathmunge ~/scripts after
pathmunge /usr/local/opt/node@6/bin after
pathmunge /sbin after
pathmunge /usr/sbin after


## History shenanigans (I keep changing this, can't decide what I like):
shopt -s histappend
HISTCONTROL=ignoredups:erasedups
HISTSIZE=100000
HISTFILESIZE=100000
## HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -n; history -w; history -c; history -r'


# Sort of specific to work but might be useful for other places utilizing jumphosts and shared home dirs
# If my home dir is NFS, then I am assuming I have a shared home dir and I'll use different HISTFILES per host
if [[ $(df -PT . | awk '{print $2}' | grep -v Type) = "nfs" ]] ; then
  HISTFILE="$HOME/.bash_history_$(hostname -s)"
fi


## Misc things that I like:
set -o vi
export LESS="-XF"
export SYSTEMD_LESS="FRXMK"
export BC_ENV_ARGS=$HOME/.bcrc

_myos="$(uname)"
case "$_myos" in
  Darwin) alias ls='ls -G';;
  *) alias ls='ls --color=auto';;
esac

alias steal_screen='screen -d -R'
alias h='ssh -A -t www.rhelfand.org ssh -A -t rhelfand.dyndns.org'
alias ha='ssh-add --apple-use-keychain ~/.ssh/id_rsa_home'
alias wa='ssh-add --apple-use-keychain ~/.ssh/id_rsa'
alias rm='rm -i'
alias cp='cp -i'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias c='cal -3'
alias sortdisk='sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'
alias showzombies="ps xaw -o state -o ppid | grep Z | grep -v PID | awk '{print $2}'"
alias kickpuppet="sudo service puppet restart && sudo tail -f /var/log/messages"
alias checknagios="sudo /usr/sbin/nagios -v /etc/nagios/nagios.cfg"
alias p4diff="P4DIFF=vimdiff p4 diff"
alias findbigfiles="find . -size +$1k -exec du -h {} \;"
alias sr="sudo ssh $1"
alias dstop='docker stop $(docker ps -a -q)'
alias dremove='docker rm $(docker ps -a -q)'
alias gla='git log --pretty=medium --graph --abbrev-commit --all'
alias gl='git log --oneline --graph --abbrev-commit --all'
alias hr='history -r'


## Crazy alias to setup tmux / iTerm2 / ssh
alias ta='export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock; LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH; $HOME/local/bin/tmux -CC new-session -A -s main'


## autocompletion (NOTE: only works with newer version of bash)
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
bind 'set menu-complete-display-prefix on'


## TODO Make my bashrc more OS agnostic maybe?
## PATH and bash completion things - Need to brew install git and bash-completion which we should be doing
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
[[ -r "/usr/local/bin/terraform" ]] && complete -C /usr/local/bin/terraform terraform

## pyenv things
#if [ -x "$(command -v pyenv)" ] ; then
#  export PYENV_ROOT="$HOME/.pyenv"
#  pathmunge $PYENV_ROOT/bin before
#  eval "$(pyenv init --path)"
#  eval "$(pyenv virtualenv-init -)"
#fi


## Cool thing that shows some system stats
[[ -x $(command -v fastfetch) ]] && fastfetch


## Use color in my prompt because I think it's cool
case "$TERM" in
    xterm|xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    # Use my crazy color_prompt
    . "$HOME/.bash_prompt"
else
    PS1="\u@\h:\w>"
fi

