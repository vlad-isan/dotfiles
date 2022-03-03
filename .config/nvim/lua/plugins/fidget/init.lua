return {
  "j-hui/fidget.nvim",
  config = function()
    require("plugins.fidget.config")
  end,
  event = { "BufNew", "BufNewFile", "BufRead" },
  module = "fidget",
}
