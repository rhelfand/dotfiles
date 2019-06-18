# User specific aliases and functions

PS1="\u@\h:\w>"

## History shenanigans:
HISTSIZE=20000
HISTFILESIZE=20000
shopt -s histappend
PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"

## Misc:
set -o vi

LESS="-XF"
BC_ENV_ARGS=$HOME/.bcrc

alias steal_screen='screen -d -R'
alias h='ssh -A -t www.rhelfand.org ssh -A -t rhelfand.dyndns.org'
alias ha='ssh-add -K ~/.ssh/id_rsa_home'
alias wa='ssh-add -K ~/.ssh/id_rsa'
alias ls='ls -G'
alias rm='rm -i'
alias cp='cp -i'
alias c='cal -3'
alias sortdisk='sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'
alias showzombies="ps xaw -o state -o ppid | grep Z | grep -v PID | awk '{print $2}'"
alias kickpuppet="sudo service puppet restart && sudo tail -f /var/log/messages"
alias checknagios="sudo /usr/sbin/nagios -v /etc/nagios/nagios.cfg"
alias p4diff="P4DIFF=vimdiff p4 diff"
alias findbigfiles="find . -size +$1k -exec du -h {} \;"
alias sr="sudo ssh $1"

# Crazy alias to setup tmux / iTerm2 / ssh
alias ta='export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock; LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH; ($HOME/local/bin/tmux ls | grep -vq attached && $HOME/local/bin/tmux -CC attach) || $HOME/local/bin/tmux -CC'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Source the stuff in bash_env
for file in ~/bash_env/*
  do
    . $file
  done
