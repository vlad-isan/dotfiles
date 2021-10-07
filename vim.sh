NVIM_DIR=$HOME/.config/nvim
NVIM_LUA_DIR=$NVIM_DIR/lua

mkdir -p $NVIM_DIR $NVIM_LUA_DIR

ln -sfnhi ${PWD}/.config/nvim/init.lua ${NVIM_DIR}

