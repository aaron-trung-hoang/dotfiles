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

require("lazy").setup('plugins')
