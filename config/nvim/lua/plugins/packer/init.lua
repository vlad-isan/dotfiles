-- Install packer if it doesn't exist
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Only run if packer is configured as opt
-- vim.cmd("packadd packer.nvim")

local plugins = {
  { "nvim-lua/plenary.nvim", module = "plenary" },
  { "ray-x/lsp_signature.nvim" },
  { "yamatsum/nvim-nonicons", requires = { { "kyazdani42/nvim-web-devicons" } } },
  { "jose-elias-alvarez/nvim-lsp-ts-utils" },
  { "b0o/schemastore.nvim" },
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
  require("plugins.autopairs"), -- FIXME: glitch on <CR>
  -- require("plugins.pears"), -- work best with treesitter
  require("plugins.telescope"),
  require("plugins.gitsigns"),
  require("plugins.outline"),
  require("plugins.neoscroll"),
  require("plugins.themes"),
  require("plugins.devicons"),
  require("plugins.lualine"),
  -- require("plugins.colorizer"), -- This makes everything super slow why the fuck are we using it?????
  require("plugins.modes"),
  require("plugins.todo-comments"),
  require("plugins.trouble"),
  require("plugins.headlines"),
  require("plugins.notify"),
  require("plugins.fidget"),
  require("plugins.fugitive"),
  require("plugins.tree"),
  require("plugins.toggleterm"),
  require("plugins.indent"),
  { "baskerville/vim-sxhkdrc" },
}

local packer = require("packer")
local config = require("plugins.packer.config")
packer.init(config.init)
packer.startup(config.use(plugins, packer_bootstrap))
