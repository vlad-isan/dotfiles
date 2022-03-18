return {
  "nvim-telescope/telescope.nvim",
  requires = {
    { "nvim-lua/plenary.nvim" },
    {
      "nvim-telescope/telescope-file-browser.nvim",
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
  config = function()
    require("plugins.telescope.config")
    require("plugins.telescope.event")
    require("plugins.telescope.keymap")
  end
}
