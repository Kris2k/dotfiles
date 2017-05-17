# ~/.bashrc: executed by bash(1) for non-login shells.
# Disable suspend and resume keys (^S,^Q, ctrl-s, ctrl-q) for interastive shell's
if [[ $- == *i* ]]; then
    stty stop ''
    stty susp ''
fi

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

tm() {
    [[ -z "$1" ]] && { echo "usage: tm <session>" >&2; return 1; }
    tmux has -t $1 && tmux attach -t $1 || tmux new -s $1
}

locale -a|grep -i en_GB.UTF8 > /dev/null 2>&1
if [[ $? -eq 0 ]] ; then
    export LC_ALL="en_GB.UTF-8"
fi

export EDITOR=vi
export PAGER=less
export LESS='--quit-if-one-screen --no-init -~ --RAW-CONTROL-CHARS --ignore-case'
# You may uncomment the following lines if you want `ls' to be colorized:
[[ -f /etc/bash_completion.d/git-prompt ]] && { source /etc/bash_completion.d/git-prompt ; export  GIT_PS1=__git_ps1 ; } || export GIT_PS1=''
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.aliases-$HOSTNAME ]] && source ~/.aliases-$HOSTNAME
[[ -d ~/.bash_compleation.d ]] && source ~/.bash_compleation.d/*
[[ -d ~/.bash_scripts ]] && source ~/.bash_scripts/*
[[ $EUID == 0 ]]  && USR_CLR="\033[31m" || USR_CLR=''

PS1="\\[\\033]0;\$MSYSTEM:\${PWD//[^[:ascii:]]/?}\\007\\]\\n\\[\\033[32m\\]${USR_CLR}\u\\[\\033[32m\\]@\\h \\[\\033[35m\\]\$MSYSTEM \\[\\033[33m\\]\\w \`$GIT_PS1\`\\[\\033[0m\\]\\n\$ "
