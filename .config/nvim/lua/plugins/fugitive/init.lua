return {
    "tpope/vim-fugitive",
    config = function()
        require("plugins.fugitive.keymap")
    end,
    module = "fugitive",
    opt = false
}
