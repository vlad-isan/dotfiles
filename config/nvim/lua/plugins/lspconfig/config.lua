local lsp = require("lspconfig")
local setup = require("lsp.config")

local servers = {
  angularls = setup.with("angular-language-server"),
  bashls = setup.with("bash-language-server"),
  clangd = require("lsp.config.clangd"),
  cmake = setup.with("cmake-language-server"),
  cssls = setup.with("vscode-css-language-server"),
  -- denols = require("lsp.config.denols"),
  dockerls = setup.with("docker-langserver"),
  dotls = setup.with("dot-language-server"),
  emmet_ls = require("lsp.config.emmet_ls"), -- FIX: Integration with auto pairs plugin
  eslint = setup.with("vscode-eslint-language-server"),
  graphql = setup.with("graphql-lsp"),
  gopls = require("lsp.config.gopls"),
  hls = require("lsp.config.hls"),
  html = setup.with("vscode-html-language-server"),
  intelephense = setup.with("intelephense"),
  jsonls = require("lsp.config.jsonls"),
  kotlin_language_server = setup.with("kotlin-language-server"),
  --lemminx = setup.with("lemminx"),
  --omnisharp = require("lsp.config.omnisharp"),
  --phpactor = setup.with("phpactor"),
  pyright = require("lsp.config.pyright"),
  --stylelint_lsp = require("lsp.config.stylelint"),
  sumneko_lua = require("lsp.config.sumneko_lua"),
  tailwindcss = require("lsp.config.tailwindcss"),
  taplo = setup.with("taplo-lsp"),
  --texlab = require("lsp.config.texlab"),
  tsserver = require("lsp.config.tsserver"),
  yamlls = setup.with("yaml-language-server"),
  vls = setup.with("vls"),
}

for server, config in pairs(servers) do
  if config then
    lsp[server].setup(config)
  end
end
