return {
  "kyazdani42/nvim-tree.lua",
  requires = {
    { "kyazdani42/nvim-web-devicons" }
  },
  config = function()
    require("plugins.tree.config")
    require("plugins.tree.keymap")
  end
}
