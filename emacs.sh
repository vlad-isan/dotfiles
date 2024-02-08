#!/bin/bash

DOTFILES_DIR=$(dirname $(readlink -f $0))

EMACS_CONFIG_DIR=$HOME/.emacs.d
EMACS_LAUNCH_AGENT_DIR=$HOME/Library/LaunchAgents

EMACS_ORG_DIR=$HOME/Documents/org
EMACS_ORG_ROAM_DIR=$EMACS_ORG_DIR/roam
EMACS_DEV_DIR=$HOME/dev
EMACS_GIT_DIR=$HOME/dev/emacs

mkdir -p $EMACS_CONFIG_DIR $EMACS_LAUNCH_AGENT_DIR
mkdir -p $EMACS_ORG_DIR $EMACS_ORG_ROAM_DIR
mkdir -p $EMACS_DEV_DIR $EMACS_GIT_DIR

ln -sfnvh ${EMACS_ORG_DIR} $HOME

ln -sfnvh ${DOTFILES_DIR}/config/emacs/org.gnu.emacs.daemon.plist ${EMACS_LAUNCH_AGENT_DIR}

cp ${DOTFILES_DIR}/config/emacs/.authinfo $HOME

ln -sfnvh ${DOTFILES_DIR}/config/emacs/.emacs.d/init.el ${EMACS_CONFIG_DIR}
ln -sfnvh ${DOTFILES_DIR}/config/emacs/.emacs.d/config.org ${EMACS_CONFIG_DIR}

CUR_DIR=$(pwd)

cd $EMACS_DEV_DIR

git clone git://git.savannah.gnu.org/emacs.git
cd ./emacs/
git checkout emacs-29
CC=gcc-12 ./autogen.sh

CPPFLAGS="-I/opt/homebrew/opt/jpeg/include" \
    LDFLAGS="-L/opt/homebrew/opt/jpeg/lib" \
    ./configure --with-native-compilation=aot --with-tree-sitter \
    --with-gif --with-png --with-jpeg --with-json --with-mailutils --with-rsvg --with-tiff \
    --with-imagemagick --with-xwidgets --with-ns

make
make install

cd $CUR_DIR

launchctl load -w ${EMACS_LAUNCH_AGENT_DIR}/org.gnu.emacs.daemon.plist
