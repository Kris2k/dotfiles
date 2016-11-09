#!/bin/tcsh

if ( -z "$1" ) then
  echo "usage: tm <session>" >&2
  return 1;
endif
tmux has -t $1 && tmux attach -t $1 || tmux new -s $1

