local keymap = require("lib.keymap")
local on = keymap.on_press
local lead = keymap.on_press_leader
local opt = keymap.opt

keymap.bind({

}, {
  options = opt():noremap(),
})
