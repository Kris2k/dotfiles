#!/bin/bash
set -e
PWD=$(pwd)
if [ ! -d ~/dotfiles ]; then
    echo "Can't find dotfiles exiting"
    exit 1
fi

BACKUP_DIR=$HOME/dotfiles/backup/$(date +'%Y-%m-%d_%H:%M:%S')
SRC_DIR=${PWD}
DST_DIR=${HOME}

if [ -d ${BACKUP_DIR} ] ; then 
    echo "Backup dir: ${BACKUP_DIR} exitst, move it to sth else"
    echo "mv ${BACKUP_DIR} ${BACKUP_DIR}-1"
    exit 1
fi

mkdir -p ${BACKUP_DIR}

do_install() {
    src=$1
    tgt=$2
    if [ -e ${tgt} ] ; then
        echo "File exists: ${tgt} moving to backup in ${BACKUP_DIR};"
        mv ${tgt} ${BACKUP_DIR}/${f}
    fi
    
    if [ ! -e ${tgt} ] ; then
        ln -s ${src} ${tgt}
    fi
}
cd ~/dotfiles/
filesToCopy=$(find . -maxdepth 1 -name '.*' -not -name .gitignore -not -name .git -not -name . -print|sed 's/^\.\///')
for f in ${filesToCopy} ; do
    src="${SRC_DIR}/${f}"
    tgt="${DST_DIR}/${f}"
done
