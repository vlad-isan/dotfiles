vim.cmd("packadd packer.nvim")

local plugins = {
  { "nvim-lua/plenary.nvim", module = "plenary" },
  { "ray-x/lsp_signature.nvim", module = "lsp_signature" },
  { "yamatsum/nvim-nonicons", module = "nvim-nonicons" },
  { "jose-elias-alvarez/nvim-lsp-ts-utils", module = "nvim-lsp-ts-utils" },
  { "b0o/schemastore.nvim", module = "schemastore" },
  require("plugins.filetype"),
  require("plugins.treesitter"),
  require("plugins.lspconfig"),
  require("plugins.clangdext"),
  require("plugins.jdtls"),
  require("plugins.rust-tools"),
  require("plugins.flutter-tools"),
  require("plugins.crates"),
  require("plugins.null-ls"),
  require("plugins.sandwich"),
  require("plugins.kommentary"),
  require("plugins.hop"),
  require("plugins.cmp"),
  -- require("plugins.autopairs"), -- FIXME: glitch on <CR>
  require("plugins.pears"), -- work best with treesitter
  require("plugins.telescope"),
  require("plugins.gitsigns"),
  require("plugins.outline"),
  require("plugins.neoscroll"),
  require("plugins.themes"),
  require("plugins.devicons"),
  require("plugins.lualine"),
  require("plugins.colorizer"),
  require("plugins.modes"),
  require("plugins.todo-comments"),
  require("plugins.trouble"),
  require("plugins.headlines"),
  require("plugins.notify"),
  require("plugins.fidget"),
  { "baskerville/vim-sxhkdrc", ft = "sxhkdrc" },
}

local packer = require("packer")
local config = require("plugins.packer.config")
packer.init(config.init)
packer.startup(config.use(plugins))
