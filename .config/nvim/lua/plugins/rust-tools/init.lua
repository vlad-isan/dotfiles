return {
  "simrat39/rust-tools.nvim",
  config = function()
    require("plugins.rust-tools.config")
  end,
  ft = { "rust" },
  module = "rust-tools",
}
