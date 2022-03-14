#!/bin/bash

NVIM_DIR=$HOME/.config/nvim
NVIM_LUA_DIR=$NVIM_DIR/lua

mkdir -p $NVIM_DIR $NVIM_LUA_DIR

ln -sfnvh ${PWD}/config/nvim/init.lua ${NVIM_DIR}

ln -sfnvh ${PWD}/config/nvim/lua/selene.toml ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/config/nvim/lua/stylua.toml ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/config/nvim/lua/vim.toml ${NVIM_LUA_DIR}

ln -sfnvh ${PWD}/config/nvim/lua/helpers ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/config/nvim/lua/keymaps ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/config/nvim/lua/lib ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/config/nvim/lua/lsp ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/config/nvim/lua/plugins ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/config/nvim/lua/settings ${NVIM_LUA_DIR}
