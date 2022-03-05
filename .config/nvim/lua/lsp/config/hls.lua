local setup = require("lsp.config")

return setup.with("haskell-language-server", {
  settings = {
    haskell = {
      formattingProvider = "brittany",
      maxCompletions = 10,
    },
  },
})
