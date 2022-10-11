local keymap = require("keymaps.lsp")
local event = require("lsp.event")
local command = {
  buffer = require("lsp.command.buffer"),
  codelens = require("lsp.command.codelens"),
  diagnostic = require("lsp.command.diagnostic"),
}
local ui = { diagnostic = require("lsp.ui.diagnostic") }

return function(client, bufnr)
  if client.server_capabilities.code_lens then
    vim.lsp.codelens.refresh()
  end
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  command.buffer.attach(client)
  command.codelens.attach(client)
  command.diagnostic.attach()
  keymap.attach(bufnr)
  event.attach(client)
  ui.diagnostic.attach()
end
