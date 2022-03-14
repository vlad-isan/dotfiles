#!/bin/bash

nohup kitty --session ./.config/kitty/conf.d/storengy-session.conf < /dev/null > /dev/null 2>&1 &
disown
