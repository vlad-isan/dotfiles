NVIM_DIR=$HOME/.config/nvim
NVIM_LUA_DIR=$NVIM_DIR/lua

mkdir -p $NVIM_DIR $NVIM_LUA_DIR

ln -sfnvh ${PWD}/.config/nvim/init.lua ${NVIM_DIR}

ln -sfnvh ${PWD}/.config/nvim/lua/keybinds.lua ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/.config/nvim/lua/options.lua ${NVIM_LUA_DIR}

ln -sfnvh ${PWD}/.config/nvim/lua/plugins ${NVIM_LUA_DIR}
