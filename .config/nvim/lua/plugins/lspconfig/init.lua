local M = {
  "neovim/nvim-lspconfig",
  config = function()
    require("plugins.lspconfig.config")
  end,
  --ft = {
  --  "bib",
  --  "cs",
  --  "css",
  --  "dockerfile",
  --  "go",
  --  "gomod",
  --  "haml",
  --  "handlebars",
  --  "haskell",
  --  "hbs",
  --  "html",
  --  "javascript",
  --  "javascriptreact",
  --  "json",
  --  "jsonc",
  --  "kotlin",
  --  "less",
  --  "lua",
  --  "php",
  --  "pug",
  --  "python",
  --  "sass",
  --  "scss",
  --  "sh",
  --  "slim",
  --  "sss",
  --  "stylus",
  --  "svg",
  --  "tex",
  --  "toml",
  --  "typescript",
  --  "typescriptreact",
  --  "vb",
  --  "vue",
  --  "xml",
  --  "xsd",
  --  "xsl",
  --  "xslt",
  --  "yaml",
  --  "zig",
  --  "zir",
  --},
  module = "lspconfig",
}

return M
