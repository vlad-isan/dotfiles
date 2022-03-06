return {
  "p00f/clangd_extensions.nvim",
  requires = { "neovim/nvim-lspconfig" },
  config = function()
    require("plugins.clangdext.config")
  end
}
