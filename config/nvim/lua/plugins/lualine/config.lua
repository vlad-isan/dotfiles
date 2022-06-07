local lualine = require("lualine")
local align = require("plugins.lualine.component.util.alignment")
local custom = {
  extension = require("plugins.lualine.extension"),
  component = require("plugins.lualine.component"),
}
local mode = custom.component.mode
local file = custom.component.file
local state = custom.component.state
local git = custom.component.git
local spacer = custom.component.spacer
local strip = {
  L = custom.component.strip("left"),
  R = custom.component.strip("right"),
}
local config = {}

config.options = {
  icons_enabled = true,
  theme = require("plugins.themes.lualine"),
  component_separators = "",
  section_separators = "",
  disabled_filetypes = { "Outline" },
  always_divide_middle = true,
  globalstatus = false,
}

config.extensions = { "quickfix" }
for _, extension in pairs(custom.extension) do
  table.insert(config.extensions, extension)
end

config.sections = {}
config.inactive_sections = {}
for _, v in ipairs({ "a", "b", "c", "x", "y", "z" }) do
  local section = ("lualine_%s"):format(v)
  config.sections[section] = {}
  config.inactive_sections[section] = {}
end

config.sections.lualine_a = { strip.L, align.left(mode) }
config.sections.lualine_c = {
  spacer(),
  align.left(state.readonly),
  align.left(file.icon.active),
  align.left(file.name),
  align.no(state.modified),
  { "diagnostics", sources = { "nvim_diagnostic" } },
}
config.sections.lualine_x = {
  align.right(git.diff),
  git.branch,
  align.right(file.location),
}
config.sections.lualine_z = { align.right(file.lines), strip.R }

config.inactive_sections.lualine_c = { "%=", file.icon.inactive, file.name }

lualine.setup(config)
