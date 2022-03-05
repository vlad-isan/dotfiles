return {
  "simrat39/symbols-outline.nvim",
  config = function()
    require("plugins.outline.config")
  end,
  cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
  keys = "<F8>",
}
