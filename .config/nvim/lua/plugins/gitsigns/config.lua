local gitsigns = require("gitsigns")
local sign = require("helpers.sign")
local formatter = require("plugins.gitsigns.formatter")

gitsigns.setup({
  signs = {
    add = { text = sign.line.SHADE.light },
    change = { text = sign.line.SHADE.light },
    delete = { text = sign.line.SHADE.light },
    topdelete = { text = sign.line.SHADE.light },
    changedelete = { text = sign.line.SHADE.light },
  },
  on_attach = function(bufnr)
    ---- NOTE: Wokraround until gitsigns command accept args
    require("lib.command").add("Blame", function()
      gitsigns.blame_line({ full = true })
    end, { buf = bufnr })
    require("plugins.gitsigns.keymap").attach(bufnr)
  end,
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = formatter.current_line_blame,
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'rounded',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
})
