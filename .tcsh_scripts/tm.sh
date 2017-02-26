#!/bin/tcsh

if ( $# < 1 )  then
  echo "usage: tm <session>" ;
  exit 1;
endif

setenv HOSTNAME $HOST
ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh-auth-sock.$HOSTNAME"
tmux has -t $1 && tmux attach -t $1 || tmux new -s $1


