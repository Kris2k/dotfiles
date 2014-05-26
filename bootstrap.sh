#!/bin/sh
set -e

DST_DIR=$HOME
SRC_DIR=$(pwd)

DOTFILES_DIR=${DST_DIR}/dotfiles
SSH_DIR=${DST_DIR}/.ssh

if [ ! -d ${DOTFILES_DIR} ] ; then
    mkdir -p ${DOTFILES_DIR}
fi

append_if_exists()
{
    src=$1
    dst=$2
    if [ -f $dst ]; then
        cat $src >> $src
    fi

}

if [ ! -d ${SSH_DIR} ] ; then
    mkdir ${SSH_DIR}
    chmod 700 ${SSH_DIR}
fi

if [ -d ${SSH_DIR} ]; then
    append_if_exists ${SRC_DIR}/ssh/authorized_keys2 ${SSH_DIR}/authorized_keys
    append_if_exists ${SRC_DIR}/ssh/authorized_keys2 ${SSH_DIR}/authorized_keys2
fi


cd ${DOTFILES_DIR}
if [ ! -d .git ] ; then
    git clone git@github.com:Kris2k/dotfiles .
fi

git submodule init
git submodule update
./install.sh
# need to handle private stuff like
# .ssh
# keys should be protected by password so
# if thye are intercepted they are usles
