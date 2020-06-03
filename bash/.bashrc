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

pathmunge ~/scripts after
pathmunge /usr/local/opt/node@6/bin after
pathmunge ~/.rvm/bin after
pathmunge /sbin after
pathmunge /usr/sbin after


## History shenanigans:
# The below command, along with 'shopt' worked to sync hisstory between tabs but it gets slow and I don't really need it
# PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"
# I tried the below commands because I thought it would be more tidy, but I think I prefer it simppler and more standard
#[[ -d ~/log ]] || mkdir ~/log
# PROMPT_COMMAND=' history -a; history -n; echo "$(date '+%Y-%m-%d.%H:%M:%S') $(pwd) $(history 1)" >> ~/log/bash-history-$(date '+%Y-%m').log'
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=500000
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -a'
# Sort of specific to athenahealth but might be useful for other places utilizing jumphosts and shared home dirs
# If my home dir is NFS, then I am assuming I have a shared home dir and I'll use different HISTFILES per host
if [[ $(df -PT . | awk '{print $2}' | grep -v Type) = "nfs" ]] ; then
  HISTFILE="$HOME/.bash_history_$(hostname -s)"
fi


## Misc things that I like:
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
alias dstop='docker stop $(docker ps -a -q)'
alias dremove='docker rm $(docker ps -a -q)'
alias gla='git log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit --branches --remotes'
alias gl='git log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit'


## Crazy alias to setup tmux / iTerm2 / ssh
alias ta='export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock; LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH; ($HOME/local/bin/tmux ls | grep -vq attached && $HOME/local/bin/tmux -CC attach) || $HOME/local/bin/tmux -CC'


## Things that are really only specific to athenahealth
export P4PORT=perforce.athenahealth.com:1666
export P4CLIENT=rhelfand-mbp15
export P4EDITOR=vim
export AWS_PROFILE=saml
# Possibly for harr?  I don't really know/remember
export INTRANET_HOME="$P4_HOME/intranet"
export MASTER_ROOT_INSTANCE=DB1
export FILEROOT=/mp/var
export ISDEVSERVER=Y

# Some aliases I use
alias b='ssh bastion100.athenahealth.com'
alias cdpuppet='cd ~/p4/quicksync/puppet/'

# athena-specific PATHs
pathmunge /usr/local/athena/techops/prodsys/tools after
pathmunge /usr/local/athena/techops/coredev/bin after
pathmunge /usr/local/bin/athena after


## autocompletion (NOTE: only works with newer version of bash)
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
bind 'set menu-complete-display-prefix on'


## Git path completion - Need to brew install git and bash-completion which we should be doing
## TODO Make my bashrc more OS agnostic maybe?
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"


## rvm things
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


## pyenv things
if [ -x "$(command -v pyenv)" ] ; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi


## Cool thing that shows some system stats
[[ -x $(command -v neofetch) ]] && neofetch


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
