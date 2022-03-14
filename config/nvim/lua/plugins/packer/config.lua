local M = {}

M.init = {
  git = {
    clone_timeout = 180, -- Timeout, in seconds
  },
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
  profile = {
    enable = true,
    -- integer in milliseconds, plugins which load faster than this
    -- won't be shown in profile output
    threshold = 1,
  },
}

function M.use(plugins, packer_bootstrap)
  return function(use)
    use "wbthomason/packer.nvim"
    for _, plugin in ipairs(plugins) do
      use(plugin)
    end

    if packer_bootstrap then
      require('packer').sync()
    end

  end
end

return M
