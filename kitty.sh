KITTY_DIR=$HOME/.config/kitty

mkdir -p $KITTY_DIR

ln -sfnvh ${PWD}/.config/kitty/theme.conf ${KITTY_DIR}
ln -sfnvh ${PWD}/.config/kitty/kitty.conf ${KITTY_DIR}
