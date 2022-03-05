local M = {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("plugins.colorizer.config")
    require("plugins.colorizer.keymap")
  end,
  cmd = {
    "ColorizerAttachToBuffer",
    "ColorizerDetachFromBuffer",
    "ColorizerReloadAllBuffers",
    "ColorizerToggle",
  },
  keys = { "n", "<Leader>cc" },
}

return M
