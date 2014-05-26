#!/bin/sh
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

do_install()
{
    src=$1
    tgt=$2

    if [ -f ${tgt} ] ; then
        echo "File exists: ${tgt} moving to backup in ${BACKUP_DIR};"
        mv ${tgt} ${BACKUP_DIR}/${f}
    fi

    if [ ! -f ${tgt} ] ; then
        ln -s ${src} ${tgt}
    fi

}
# FIXME: use exclude-files option
for f in $(find . -maxdepth 1 -name '.*' -not -name .gitignore -not -name .git -not -name . -print|sed 's/^\.\///')
do
    src="${SRC_DIR}/${f}"
    tgt="${DST_DIR}/${f}"
    do_install ${src} ${tgt}
done
