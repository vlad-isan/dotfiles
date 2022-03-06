return {
  "folke/trouble.nvim",
  requires = { "kyazdani42/nvim-web-devicons" },
  config = function()
    require("plugins.trouble.config")
    require("plugins.trouble.keymap")
  end
}
