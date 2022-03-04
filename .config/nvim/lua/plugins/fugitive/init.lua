return {
    "tpope/vim-fugitive",
    --config = function()
    --    require("plugins.fugitive.keymap")
    --end,
    --module = "fugitive",
    opt = false,
    cmd = {
        "G", "GcLog", "Gclog", "Git", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gsplit",
        "Gread", "Gwrite", "Ggrep", "Glgrep", "Gmove",
        "Gdelete", "Gremove", "Gbrowse",
    }
}
