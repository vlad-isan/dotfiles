return {
  "nvim-lualine/lualine.nvim",
  requires = {
    { "kyazdani42/nvim-web-devicons" },
    {
      "arkav/lualine-lsp-progress",
      module = "lualine.components.lsp_progress",
    },
  },
  config = function()
    require("plugins.lualine.config")
  end,
  event = { "BufReadPost", "BufNewFile" },
  module = "lualine",
}
