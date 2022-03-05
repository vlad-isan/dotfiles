return {
  "windwp/nvim-autopairs",
  config = function()
    require("plugins.autopairs.config")
  end,
  event = "InsertCharPre",
}
