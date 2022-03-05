return {
  "folke/tokyonight.nvim",
  config = function()
    require("plugins.themes.tokyonight.config")
  end,
  event = "VimEnter",
  module = "tokyonight",
}
