return {
  "rcarriga/nvim-notify",
  config = function()
    require("plugins.notify.config")
  end,
  event = { "BufNew", "BufNewFile", "BufRead" },
}
