local M = {
  "lewis6991/gitsigns.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("plugins.gitsigns.config")
  end,
  keys = "gs",
  module = "gitsigns",
}

return M
