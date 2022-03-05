local command = require("lib.command")

-- dir helper
command.add("MakeDir", require("helpers.dir").mk)

-- tmux helper
command.group({
  prefix = "TmuxMove",
  cmds = {
    {
      name = "H",
      cmd = function()
        require("helpers.tmux").move("h")
      end,
    },
    {
      name = "J",
      cmd = function()
        require("helpers.tmux").move("j")
      end,
    },
    {
      name = "K",
      cmd = function()
        require("helpers.tmux").move("k")
      end,
    },
    {
      name = "L",
      cmd = function()
        require("helpers.tmux").move("l")
      end,
    },
  },
})

-- zen helper
command.group({
  prefix = "ZenToggle",
  cmds = {
    { cmd = require("helpers.zen").toggle },
    {
      name = "Full",
      cmd = function()
        require("helpers.zen").toggle({ laststatus = true })
      end,
    },
  },
})
