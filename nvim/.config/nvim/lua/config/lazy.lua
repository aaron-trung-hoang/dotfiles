-- Bootstrap lazy.nvim into Neovim's data directory on a fresh machine.
-- If cloning fails, show Git's output and stop before loading partial config.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local lazy_repository = "https://github.com/folke/lazy.nvim.git"
  local clone_output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazy_repository,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { clone_output, "WarningMsg" },
    }, true, {})

    if #vim.api.nvim_list_uis() > 0 then
      vim.api.nvim_echo({ { "Press any key to exit..." } }, true, {})
      vim.fn.getchar()
    end

    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Import every spec from lua/plugins, where files are grouped by purpose.
-- Individual specs can still override the eager default with event, cmd, keys, or lazy.
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false, -- Load custom plugins unless their spec says otherwise.
    version = false, -- Follow current commits unless a spec pins a release.
  },
  install = {
    colorscheme = { "catppuccin-mocha", "habamax" }, -- Safe themes during first install.
  },
  checker = {
    enabled = true, -- Check periodically for available plugin updates.
    notify = false, -- Keep update checks quiet.
  },
  performance = {
    rtp = {
      -- Remove unused built-in runtime plugins from startup.
      -- File search and archive browsing are handled by the configured tools.
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
