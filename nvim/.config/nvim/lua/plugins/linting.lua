return {
  -- Run standalone linters and publish their findings through vim.diagnostic.
  -- ShellCheck adds portability and quoting checks that bashls does not provide;
  -- Lua and YAML keep their existing LSP diagnostics without duplicate linters.
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>cL",
        function()
          require("lint").try_lint()
        end,
        desc = "Lint buffer",
      },
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        bash = { "shellcheck" },
        sh = { "shellcheck" },
      }

      -- Refresh diagnostics after entering or saving a file and after typing.
      -- Other filetypes are ignored because they have no configured linter.
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("dotfiles_lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })

      -- BufReadPost loads this plugin after the initial event has already fired.
      -- Schedule one pass so the first opened shell file receives diagnostics too.
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(0) then
          lint.try_lint()
        end
      end)
    end,
  },
}
