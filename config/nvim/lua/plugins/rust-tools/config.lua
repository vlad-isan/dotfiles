require("rust-tools").setup({
  tools = {
    hover_actions = { auto_focus = true },
  },
  server = {
    capability = require("lsp.capability"),
    handlers = require("lsp.handler").default(),
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "self",
        },
        cargo = {
          loadOutDirsFromCheck = true
        },
        -- enable clippy on save
        check = {
            command = "clippy"
        },
        checkOnSave = true,
        hoverActions = { references = true },
        procMacro = {
          enable = true
        },
        rustfmt = { enableRangeFormatting = true },
      },
    },
    on_attach = function(client, bufnr)
      require("lsp.attach").with.all(client, bufnr)
      require("plugins.rust-tools.keymap").attach()
    end,
  },
})
