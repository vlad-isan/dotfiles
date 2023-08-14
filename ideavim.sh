#!/bin/bash

NVIM_DIR=$HOME/.config/ideavim

mkdir -p $NVIM_DIR

ln -sfnvh ${PWD}/config/ideavim/.vimrc.keymap ${HOME}
ln -sfnvh ${PWD}/config/ideavim/.ideavimrc ${HOME}
