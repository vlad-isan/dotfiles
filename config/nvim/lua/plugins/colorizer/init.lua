local M = {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("plugins.colorizer.config")
    require("plugins.colorizer.keymap")
  end
}

return M
