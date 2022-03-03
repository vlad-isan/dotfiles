return {
  "mvllow/modes.nvim",
  config = function()
    require("plugins.modes.config")
  end,
  event = { "BufReadPre", "BufNewFile" },
}
