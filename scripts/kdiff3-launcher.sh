#!/bin/zsh
os=$(uname -s)
env >> dupa
case $os in
    Linux*)
        kdiff3 $*
        ;;
    Cygwin*)
        c:\\Program Files\\Kdiff3\\kdiff3.exe $*
        ;;
    *)
        echo "Error $0 don't handle the os: $os"
        ;;
esac
