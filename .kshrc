#!/bin/ksh

# \E[bgcolor;textattribute;fgcolor 
red="\033[40;1;31m"
green="\033[40;0;32m"
yellow="\033[40;1;33m"
blue="\033[40;1;34m"
magenta="\033[40;1;35m"
cyan="\033[40;1;36m"
white="\033[40;0;37m"
end="\033[0m"

#set autolist
#set color
#set colorcat
#set nobeep
#
#set nocloberb
#set rmstat

#set promptchars="#:"
usr=
if [ $USER = root ] ; then
	usr=${red}
fi

PS1="${usr}\u${magenta}@${blue}\h ${cyan}\w ${white}[\!] ${yellow}.\A. ${end} \n${green}:->${end} "

unset red green yellow blue magenta cyan white end usr

#set history=5000
#set savehist=(5000 merge lock)
#setenv EDITOR vi
export PAGER=less
export LESS='--quit-if-one-screen --no-init --clear-screen -~ --RAW-CONTROL-CHARS --ignore-case'

#setenv LSCOLORS 'ExGxFxdxCxDxDxabadaeac'

#bindkey '^R' i-search-back
#bindkey '^F' i-search-fwd

#complete tm 'p/*/`tmux -q list-sessions|cut -f 1 -d \:`/'
#alias tm 'source ~/dotfiles/.tcsh_scripts/tm.sh'


if [ -x /usr/local/bin/colorls ] ; then 
	# instal from porsts sysutils/colorls
	alias ls='/usr/local/bin/colorls -G'
fi
alias ll='ls -Al '
alias l='ls -CF'
alias rmd='rm -rf'
alias ddate='date +"%T %d-%m-%y"'
alias cdd='cd ~/dotfiles'
alias cdn='cd ~/notes'
