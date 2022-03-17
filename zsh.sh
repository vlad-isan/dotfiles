#!/bin/bash

# Use this insteasd of $PWD, as pwd gets path from where you execute the script
DOTFILES_DIR=$(dirname $(readlink -f $0))
ZSH_DIR=$HOME/.config/zsh

mkdir -p "$ZSH_DIR"

ln -sfnvh "${DOTFILES_DIR}/config/zsh/.zshenv" "${HOME}"
ln -sfnvh "${DOTFILES_DIR}/config/zsh/.zshrc" "${ZSH_DIR}"
