#!/bin/bash

nohup kitty --session ./conf.d/eurostar-session.conf < /dev/null > /dev/null 2>&1 &
disown
