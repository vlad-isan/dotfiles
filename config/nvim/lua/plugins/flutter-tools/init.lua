return {
  "akinsho/flutter-tools.nvim",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    require("plugins.flutter-tools.config")
    require("plugins.flutter-tools.keymap")
  end,
  ft = "dart",
  event = "BufRead pubspec.yaml",
  module = "flutter-tools",
}
