return {
  "Saecki/crates.nvim",
  after = "rust-tools.nvim",
  config = function()
    require("plugins.crates.config")
  end,
  event = "BufRead Cargo.toml",
}
