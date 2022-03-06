local M = {
  "lewis6991/gitsigns.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("plugins.gitsigns.config")
  end
}

return M
