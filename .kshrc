#!/bin/ksh
# in .profile add line
# export ENV=$HOME/.kshrc
# \E[bgcolor;textattribute;fgcolor 
red="\033[40;1;31m"
green="\033[40;0;32m"
yellow="\033[40;1;33m"
blue="\033[40;1;34m"
magenta="\033[40;1;35m"
cyan="\033[40;1;36m"
white="\033[40;0;37m"
end="\033[0m"

if [ $USER = root ] ; then
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
export LSCOLORS='ExGxFxdxCxDxDxabadaeac'

set -o noclobber
set -o emacs

if [ -x /usr/local/bin/colorls ] ; then 
	# instal from porsts sysutils/colorls
	alias ls='/usr/local/bin/colorls -G'
fi

function tm {
	if [ -z $1 ]; then
		echo "usage: tm <session>" >&2
		echo $(tmux -q list-sessions|cut -f 1 -d \:) >&2
		return 1;
	fi
	tmux has -t $1 && tmux attach -t $1 || tmux new -s $1
}
alias ll='ls -Al '
alias l='ls -CF'
alias rmd='rm -rf'
alias ddate='date +"%T %d-%m-%y"'
alias cdd='cd ~/dotfiles'
alias cdn='cd ~/notes'
