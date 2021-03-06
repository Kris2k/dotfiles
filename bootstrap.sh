#!/bin/zsh
set -e

function finish() {
	if [ -f ~/.ssh/config.bak ] ;then
		mv ~/.ssh/config.bak  ~/.ssh/config
	fi
}

trap finish EXIT

SRC_DIR=$(pwd)
DST_DIR=~/
SSH_BACKUP=${DST_DIR}/.ssh/backup/$(date +'%Y-%m-%d_%H:%M:%S')
DOTFILES_DIR=${DST_DIR}/dotfiles

assert_file() {
    file=$1
    if [ ! -f $file ]; then
        echo "couldn't find file: $file"
        exit 1
    fi
}

KEY=
if [ -f ~/.ssh/id_rsa -a  $# -eq 0 ] ; then
	KEY=~/.ssh/id_rsa
else
	KEY=$1
fi
if [ ! -f $KEY  ] ; then 
	echo "There needs to be github key"
	exit 2
fi

if [ ! -d .ssh ] ; then
    mkdir .ssh
    chmod 700 .ssh
fi

if [ -f ~/.ssh/config ]; then
	mv ~/.ssh/config ~/.ssh/config.bak
fi

cat > ~/.ssh/config <<EOF
Host github.com
	user git
	IdentityFile $KEY
EOF


set +e
ssh git@github.com
if [ $? -ne 1 ] ; then
	echo "Github connection must work"
	exit 3
fi
set -e

if [ ! -d ${DOTFILES_DIR} ] ; then
    mkdir -p ${DOTFILES_DIR}
fi

cd ${DOTFILES_DIR}
if [ ! -d .git ] ; then
	git clone --recurse-submodules git@github.com:Kris2k/dotfiles .
fi

./install.sh
