NVIM_DIR=$HOME/.config/nvim
NVIM_LUA_DIR=$NVIM_DIR/lua

mkdir -p $NVIM_DIR $NVIM_LUA_DIR

# Install Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install language servers
npm i -g  @angular/language-server \
          cssmodules-language-server \
          dockerfile-language-server-nodejs \
          dot-language-server \
          vscode-langservers-extracted \
          graphql-language-service-cli \
          typescript \
          typescript-language-server

brew install bash-language-server

pip3 install cmake-language-server

ln -sfnvh ${PWD}/.config/nvim/init.lua ${NVIM_DIR}

ln -sfnvh ${PWD}/.config/nvim/lua/selene.toml ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/.config/nvim/lua/stylua.toml ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/.config/nvim/lua/vim.toml ${NVIM_LUA_DIR}

ln -sfnvh ${PWD}/.config/nvim/lua/helpers ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/.config/nvim/lua/keymaps ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/.config/nvim/lua/lib ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/.config/nvim/lua/lsp ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/.config/nvim/lua/plugins ${NVIM_LUA_DIR}
ln -sfnvh ${PWD}/.config/nvim/lua/settings ${NVIM_LUA_DIR}
