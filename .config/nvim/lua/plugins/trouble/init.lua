return {
  "folke/trouble.nvim",
  requires = { "kyazdani42/nvim-web-devicons" },
  config = function()
    require("plugins.trouble.config")
    require("plugins.trouble.keymap")
  end,
  cmd = {
    "Trouble",
    "TroubleClose",
    "TroubleToggle",
    "TroubleRefresh",
  },
  keys = {
    { "n", "[xx" },
    { "n", "[xd" },
    { "n", "[xw" },
    { "n", "[xl" },
    { "n", "[xq" },
    { "n", "[xr" },
    { "n", "[xD" },
    { "n", "[xt" },
    { "n", "[xR" },
  },
  module = "trouble",
}
