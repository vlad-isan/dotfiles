#!/bin/bash

DOTFILES_DIR=$(dirname $(readlink -f $0))

EMACS_CONFIG_DIR=$HOME/.emacs.d
EMACS_LAUNCH_AGENT_DIR=$HOME/Library/LaunchAgents

EMACS_ORG_DIR=$HOME/Documents/org
EMACS_ORG_ROAM_DIR=$EMACS_ORG_DIR/roam

mkdir -p $EMACS_CONFIG_DIR $EMACS_LAUNCH_AGENT_DIR
mkdir -p $EMACS_ORG_DIR $EMACS_ORG_ROAM_DIR

ln -sfnvh ${EMACS_ORG_DIR} $HOME


ln -sfnvh ${DOTFILES_DIR}/config/emacs/org.gnu.emacs.daemon.plist ${EMACS_LAUNCH_AGENT_DIR}

ln -sfnvh ${DOTFILES_DIR}/config/emacs/.emacs.d/init.el ${EMACS_CONFIG_DIR}
ln -sfnvh ${DOTFILES_DIR}/config/emacs/.emacs.d/config.org ${EMACS_CONFIG_DIR}

launchctl load -w ${EMACS_LAUNCH_AGENT_DIR}/org.gnu.emacs.daemon.plist

