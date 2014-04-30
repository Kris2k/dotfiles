#!/bin/bash
set -e
PWD=$(pwd)

if [ ! -f ${PWD}/$0 ] ; then
    echo "Bad working directory: $PWD, can't find self";
    exit 1
fi

BACKUP_DIR=$HOME/dotfiles-backup/$(date +'%Y-%m-%d_%H:%M:%S')
SRC_DIR=${PWD}
DST_DIR=${HOME}

mkdir -p ${BACKUP_DIR}

# FIXME: use exclude-files option
for f in $(find . -maxdepth 1 -name '.*' -type f -not -name .gitignore -print )
do
    src="${SRC_DIR}/${f}"
    tgt="${DST_DIR}/${f}"

    if [ -f ${tgt} ] ; then
        echo "File exists: ${tgt} moving to backup in ${BACKUP_DIR};"
        mv ${tgt} ${BACKUP_DIR}/${f}
    fi

    if [ ! -f ${tgt} ] ; then
        ln -s ${src} ${tgt}
    fi

done
