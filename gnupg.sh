#!/bin/bash

GNUPG_DIR=$HOME/.gnupg

mkdir -p $GNUPG_DIR

ln -sfnvh ${PWD}/config/gnupg/gpg.conf ${GNUPG_DIR}
ln -sfnvh ${PWD}/config/gnupg/gpg-agent.conf ${GNUPG_DIR}
