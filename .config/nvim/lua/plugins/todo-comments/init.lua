return {
  "folke/todo-comments.nvim",
  after = "nvim-treesitter",
  config = function()
    require("plugins.todo-comments.config")
    require("plugins.todo-comments.keymap")
  end,
}
