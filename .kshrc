#!/bin/ksh
# in .profile add line
# export ENV=$HOME/.kshrc
# \E[bgcolor;textattribute;fgcolor

red="\033[38;0;31m"
green="\033[38;0;32m"
green="\e[38;0;32m"
yellow="\033[40;0;33m"
blue="\033[38;5;33m"
magenta="\033[38;5;165m"
cyan="\033[38;0;36m"
white="\033[38;0;37m"
end="\033[0m"
id=`id -u`
if [ $id = 0 ] ; then
	usr=${red}
	usr_prompt=':'
else
	usr=${green}
	usr_prompt='#'
fi

PS1="${usr}\u${magenta}@${blue}\h ${cyan}\w ${white}[\!] ${yellow}.\A. ${end} \n${green}${usr_prompt}->${end} "

unset red green yellow blue magenta cyan white end usr
unset usr usr_prompt

export HISTFILE=$HOME/.ksh_history
export HISTSIZE=1000

export EDITOR=vi
export PAGER=less
export LESS='--quit-if-one-screen --no-init --clear-screen -~ --RAW-CONTROL-CHARS --ignore-case'

export CLICOLOR=yes
export LSCOLORS='ExGxFxdxCxDxDxabfdfeac'
export LS_COLORS="di=01;34:ln=01;36:so=01;35:pi=33:ex=01;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:st=5;31;42:tw=01;35;44:ow=30;43:"

if [ -x /usr/local/bin/vim ] ; then
    alias vi=/usr/local/bin/vim
    export EDITOR=vim
fi
if [ -x /usr/local/bin/colorls ] ; then
	# instal from porsts sysutils/colorls
	alias ls='/usr/local/bin/colorls -G'
fi

function tm {
	if [ -z $1 ]; then
		echo "usage: tm <session>" >&2
		return 1;
	fi
	tmux has -t $1 && tmux attach -t $1 || tmux new -s $1
}

alias bsd_mirror_pl="export PKG_PATH=http://ftp.icm.edu.pl/pub/OpenBSD/$(uname -r)/packages/$(uname -p)"
# alias bsd_mirror_pl="export PKG_PATH=http://piotrkosoft.net/pub/OpenBSD/$(uname -r)/packages/$(uname -p)
alias bsd_mirror_se="export PKG_PATH=http://ftp.eu.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -p)"

alias tml='tmux -q list-sessions|cut -f 1 -d \:'
alias ll='ls -Al '
alias l='ls -CF'
alias rmd='rm -rf'
alias ddate='date +"%T %d-%m-%y"'
alias cdd='cd ~/dotfiles'
alias cdn='cd ~/notes'

set -o noclobber
set -o emacs
