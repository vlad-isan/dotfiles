local THEME = os.getenv("NVIM_COLORSCHEME") or "gruvbox"
local module = ("plugins.themes.%s"):format(THEME)
local ok, result = pcall(require, module)

return ok and result
