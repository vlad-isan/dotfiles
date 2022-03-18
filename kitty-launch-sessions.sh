#!/bin/bash

DOTFILES_DIR="$(dirname $(readlink -f $0))"

"${DOTFILES_DIR}/kitty-launch-eurostar-session.sh"
"${DOTFILES_DIR}/kitty-launch-storengy-session.sh"
