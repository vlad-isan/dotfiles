local execute = vim.api.nvim_command
local fn = vim.fn

local packer_install_dir = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

local plug_url_format = 'https://github.com/%s'

local packer_repo = string.format(plug_url_format, 'wbthomason/packer.nvim')
local install_cmd = string.format('10split |term git clone --depth=1 %s %s', packer_repo, packer_install_dir)

if fn.empty(fn.glob(packer_install_dir)) > 0 then
    vim.api.nvim_echo({{'Installing packer.nvim', 'Type'}}, true, {})
    execute(install_cmd)
    execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

local plugins = {
    --{ "nvim-lua/plenary.nvim", module = "plenary" },
    --{ "ray-x/lsp_signature.nvim", module = "lsp_signature" },
    --{ "yamatsum/nvim-nonicons", module = "nvim-nonicons" },
    --{ "jose-elias-alvarez/nvim-lsp-ts-utils", module = "nvim-lsp-ts-utils" },
    --{ "b0o/schemastore.nvim", module = "schemastore" },
    --require("plugin.filetype"),
    require("plugins.treesitter"),
    --require("plugin.lspconfig"),
    --require("plugin.clangdext"),
    --require("plugin.jdtls"),
    --require("plugin.rust-tools"),
    --require("plugin.flutter-tools"),
    --require("plugin.crates"),
    --require("plugin.null-ls"),
    --require("plugin.sandwich"),
    --require("plugin.kommentary"),
    --require("plugin.hop"),
    --require("plugin.cmp"),
    --require("plugin.autopairs"), -- FIXME: glitch on <CR>
    --require("plugin.pears"), -- work best with treesitter
    --require("plugin.telescope"),
    --require("plugin.gitsigns"),
    --require("plugin.outline"),
    --require("plugin.neoscroll"),
    --require("plugin.themes"),
    --require("plugin.devicons"),
    --require("plugin.lualine"),
    --require("plugin.colorizer"),
    --require("plugin.modes"),
    --require("plugin.todo-comments"),
    --require("plugin.trouble"),
    --require("plugin.headlines"),
    --require("plugin.notify"),
    --require("plugin.fidget"),
    --{ "baskerville/vim-sxhkdrc", ft = "sxhkdrc" },
}

local packer = require("packer")
local config = require("plugins.packer.config")
packer.init(config.init)
packer.startup(config.use(plugins))