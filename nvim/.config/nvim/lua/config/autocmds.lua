-- Give each autocmd a named group that reloads cleanly.
local function augroup(name)
  return vim.api.nvim_create_augroup("dotfiles_" .. name, { clear = true })
end

-- Check whether an open file changed outside Neovim after focus or terminal use.
-- Skip utility buffers because they do not represent files on disk.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Briefly highlight copied text so the selected range is visible.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Rebalance every tab after the terminal window changes size.
-- Return to the original tab after applying equal split dimensions.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Reopen files at Vim's saved quote mark when that line still exists.
-- Commit messages intentionally start at the top for a clean writing flow.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_location"),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if vim.bo[event.buf].filetype ~= "gitcommit" and mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Keep temporary utility buffers out of the buffer list.
-- Press q inside help, health, quickfix, and plugin utility windows to close them.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "checkhealth", "gitsigns-blame", "grug-far", "help", "qf" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Quit buffer" })
  end,
})

-- Wrap prose and enable spell checking for text-focused file types.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Keep raw Markdown punctuation visible while editing or rendering is disabled.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_conceal"),
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Show JSON syntax characters that conceallevel would otherwise hide.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Create missing parent directories just before saving a local file.
-- URI-style buffers are ignored because their paths belong to another provider.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("create_parent_directory"),
  callback = function(event)
    if not event.match:match("^%w%w+:[\\/][\\/]") then
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end
  end,
})
