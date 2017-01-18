#!/bin/tcsh

set     red="%{\033[1;31m%}"
set   green="%{\033[0;32m%}"
set  yellow="%{\033[1;33m%}"
set    blue="%{\033[1;34m%}"
set magenta="%{\033[1;35m%}"
set    cyan="%{\033[1;36m%}"
set   white="%{\033[0;37m%}"
set     end="%{\033[0m%}"
if ( $USER == root ) then
	set usr="${red}%n"
else
	set usr="${green}%n"
endif

setenv GIT_BRANCH_CMD ""
if ( -d ${PWD}/.git ) then
    setenv GIT_BRANCH_CMD `git branch --no-color|sed -ne 's/^* \(.*\)/\1/p'`
    setenv GIT_BRANCH_CMD "${magenta}(${white}git${magenta})${yellow}-${magenta}[${green}${GIT_BRANCH_CMD}${magenta}]"
endif

set prompt="${usr}${magenta}@${blue}%m ${cyan}%c05 ${white}[%h] ${yellow}%B.%P.%b ${red}%? ${GIT_BRANCH_CMD}${end} \n${green}%#->${end} "

unset red green yellow blue magenta cyan white end usr
