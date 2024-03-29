require("crates").setup({
  text = {
    loading = "   Loading  ",
    version = "  ﰖ %s  ",
    prerelease = "  裂%s  ",
    yanked = "  戀%s  ",
    nomatch = "  𥉉No match  ",
    upgrade = "  療%s  ",
    error = "   Error fetching crate  ",
  },
  highlight = {
    loading = "DiagnosticVirtualTextHint",
    nomatch = "DiagnosticVirtualTextWarn",
    upgrade = "DiagnosticHint",
  },
  popup = {
    autofocus = true, -- focus the versions popup when opening it
    border = "rounded", -- same as nvim_open_win config.border
    max_height = 10,
    min_width = 20,
    text = {
      title = " 📦 %s ",
      version = "   %s ",
      prerelease = " 裂%s ",
      yanked = " 戀%s ",
      feature = "   %s ",
      enabled = " * %s ",
      transitive = " ~ %s ",
    },
    highlight = {
      title = "Title",
      version = "None",
      prerelease = "DiagnosticWarn",
      yanked = "DiagnosticError",
      feature = "DiagnosticHint",
    },
  },
})

require("plugins.crates.command")
require("plugins.crates.keymap")
