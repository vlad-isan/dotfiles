local g = vim.g
local tokyonight = require("tokyonight")


tokyonight.setup({
    style = "night",
    light_style = "day",
    transparent = false,
    terminal_colors = true,
    lualine_bold = false,
    sidebars = { "qf", "help", "Outline" },
    day_brightness = 0.3,
    hide_inactive_statusline = false,
    dim_inactive = false,
    styles = {
        comments = { italic = true },
        keywords = { italic = true},
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark"
    }
})

local config = {
  style = "night",
  lualineBold = false,
  darkFloat = false,
  darkSidebar = false,
  sidebars = { "Outline" },
}

vim.cmd("colorscheme tokyonight")

local c = require("tokyonight.colors").setup(config)
local hlgroups = {
  CursorLineNr = ("gui=BOLD guifg=%s"):format(c.blue),
  ColorColumn = ("guibg=%s"):format(c.bg_statusline),
  TabLineSel = ("guifg=%s guibg=%s"):format(c.fg, c.bg),
  TabLine = ("guifg=%s guibg=%s"):format(c.fg_gutter, c.bg_statusline),
  TabLineFill = ("guifg=%s guibg=%s"):format(c.fg_gutter, c.bg_statusline),
  DiagnosticSignError = ("gui=BOLD guifg=%s"):format(c.error),
  DiagnosticSignWarn = ("gui=BOLD guifg=%s"):format(c.warning),
  DiagnosticSignInfo = ("gui=BOLD guifg=%s"):format(c.info),
  DiagnosticSignHint = ("gui=BOLD guifg=%s"):format(c.hint),
  GitSignsAddNr = ("gui=bold guifg=%s"):format(c.gitSigns.add),
  GitSignsChangeNr = ("gui=bold guifg=%s"):format(c.gitSigns.change),
  GitSignsDeleteNr = ("gui=bold guifg=%s"):format(c.gitSigns.delete),
  GitSignsDeleteLn = ("guifg=%s"):format(c.gitSigns.delete),
}

for group, hl in pairs(hlgroups) do
  vim.cmd(("highlight %s %s"):format(group, hl))
end
