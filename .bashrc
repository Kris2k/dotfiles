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

tmup() {
    local v
    while read v; do
        if [[ $v == -* ]]; then
            unset ${v/#-/}
        else
            # Add quotes around the argument
            v=${v/=/=\"}
            v=${v/%/\"}
            eval export $v
        fi
    done < <(tmux show-environment)
}

locale -a|grep -i en_GB.UTF8 > /dev/null 2>&1
if [[ $? -eq 0 ]] ; then
    export LC_ALL="en_GB.UTF-8"
fi

export EDITOR=vi
export PAGER=less
export LESS='--no-init -~ --RAW-CONTROL-CHARS --ignore-case'
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=
__ps1_cmd() {
    local err=$?
    # local BBlue="\\033[1;34m\]"
    local BBlue=
    local BMagenta=
    # local BMagenta="\\033[1;35m\]"
    local Red="\033[31m"
    local BRed='\[\e[0;91m\]'
    local Green='\[\e[32m\]'
    local BCyan="\[\033[1;36m\]"
    local BYellow="\[\033[1;33m\]"
    local Yellow="\033[0;33m"
    local end="\[\033[0m\]"

    local EXIT_VAL=""
    [[ $EUID == 0 ]]  && { USR_CLR=${Red} ; PRMT=: ; } || { USR_CLR=${Green} ; PRMT="#" ; }
    [[ $err != 0 ]] &&  EXIT_VAL=" (${Red}$err${Yellow})"
    # xterm title settings
    PS1="\[\033]0;\u@\h: \w\007\]"
    # prompt
    PS1+="${USR_CLR}\u${BMagenta}@${BBlue}\h ${BCyan}\\w ${BYellow}.\t. ${Yellow}\`$GIT_PS1\`${EXIT_VAL}${end} \n${Green}\${PRMT}->${end} "
}
__ethernal_history() {
    echo $$ $USER "$(history 1)" >> ~/.bash_eternal_history
}
PROMPT_COMMAND="__ps1_cmd;__ethernal_history;${PROMPT_COMMAND}"
[[ -f /etc/bash_completion ]] && source /etc/bash_completion
[[ -f /etc/bash_completion.d/git-prompt ]] && { source /etc/bash_completion.d/git-prompt ; export  GIT_PS1=__git_ps1 ; } || export GIT_PS1=''
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.aliases-$HOSTNAME ]] && source ~/.aliases-$HOSTNAME
[[ -d ~/.bash_compleation.d ]] && source ~/.bash_compleation.d/*
[[ -d ~/.bash_scripts ]] && source ~/.bash_scripts/*
[[ -d ~/.bash_scripts-$HOSTNAME ]] && source ~/.bash_scripts-$HOSTNAME/*
# HACK: some bash compleation scripts leases unhandled error, this shows up in the prompt
true
