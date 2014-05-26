#!/bin/sh
set -e

SRC_DIR=$(pwd)
DST_DIR=$HOME
SRC_CONFIG=${SRC_DIR}/ssh
SSH_DIR=${DST_DIR}/.ssh
SSH_BACKUP=${DST_DIR}/.ssh/backup/$(date +'%Y-%m-%d_%H:%M:%S')
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

copy_file()
{
    src=$1
    dst=$2
    if [ -e ${src} ]; then
        set +e
        are_different=$(diff -q ${src} ${dst})
        set -e
        if [ ! -z "${are_different}" ]; then
            echo "Backing up file ${src} to ${SSH_BACKUP}"
            mkdir -p ${SSH_BACKUP}
            mv ${dst} ${SSH_BACKUP}
            cp ${src} ${dst}
        else
            echo "src: ${src} and dst: ${dst} don't differ"
        fi
    fi
}

if [ -d ${SSH_DIR} ]; then
    if [ -f ${SSH_DIR}/config ]; then
        is_configured=$(grep -e 'host.*github\.com' ${SSH_DIR}/config)
        if [ -z "${is_configured}" ]; then
            cat ${SRC_CONFIG}/config >> ${SSH_DIR}/config
        fi
    else
        cp ${SRC_CONFIG}/config ${SSH_DIR}/config
    fi
    copy_file ${SRC_CONFIG}/github ${SSH_DIR}/github
    copy_file ${SRC_CONFIG}/github.pub ${SSH_DIR}/github.pub
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
