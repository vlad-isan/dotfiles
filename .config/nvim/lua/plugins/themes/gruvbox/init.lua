return {
  "ellisonleao/gruvbox.nvim",
  config = function()
    require("plugins.themes.gruvbox.config")
  end,
  event = "VimEnter",
  module = "gruvbox"
}
