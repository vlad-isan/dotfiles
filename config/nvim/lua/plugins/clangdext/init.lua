return {
  "p00f/clangd_extensions.nvim",
  requires = { "neovim/nvim-lspconfig", module = "lspconfig" },
  config = function()
    require("plugins.clangdext.config")
  end,
  ft = { "c", "cpp" },
  module = "clangd_extensions",
}
