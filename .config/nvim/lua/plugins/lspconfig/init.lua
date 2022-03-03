local M = {
  "neovim/nvim-lspconfig",
  config = function()
    require("plugins.lspconfig.config")
  end,
  module = "lspconfig",
}

return M
