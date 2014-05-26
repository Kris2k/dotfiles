#!/bin/sh
set -e

SRC_DIR=$(pwd)
DST_DIR=$HOME
SRC_CONFIG=${SRC_DIR}/ssh
SSH_DIR=${DST_DIR}/.ssh
DOTFILES_DIR=${DST_DIR}/dotfiles

assert_file()
{
    file=$1
    if [ ! -f $file ]; then
        echo "couldn't find file: $file"
        exit 1
    fi
}

assert_file ${SRC_CONFIG}/config
assert_file ${SRC_CONFIG}/github
assert_file ${SRC_CONFIG}/github.pub

if [ ! -d ${DOTFILES_DIR} ] ; then
    mkdir -p ${DOTFILES_DIR}
fi

if [ ! -d ${SSH_DIR} ] ; then
    mkdir ${SSH_DIR}
    chmod 700 ${SSH_DIR}
fi

if [ -d ${SSH_DIR} ]; then
    if [ -f ${SSH_DIR}/config ]; then
        is_configured=$(grep -e 'host.*github\.com' ${SSH_DIR}/config)
        if [ -z $is_configured ]; then
            cat ${SRC_CONFIG}/config >> ${SSH_DIR}/config
        fi
    fi
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
