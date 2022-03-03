return {
  "steelsojka/pears.nvim",
  after = "nvim-treesitter",
  config = function()
    require("plugins.pears.config")
  end,
}
