local THEME = os.getenv("NVIM_COLORSCHEME") or "tokyonight"
local module = ("plugins.themes.%s.lualine"):format(THEME)
local ok, result = pcall(require, module)

return ok and result or "auto"
