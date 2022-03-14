#!/bin/bash

KITTY_DIR=$HOME/.config/kitty

mkdir -p $KITTY_DIR

ln -sfnvh ${PWD}/config/kitty/conf.d ${KITTY_DIR}
ln -sfnvh ${PWD}/config/kitty/kitty.conf ${KITTY_DIR}
