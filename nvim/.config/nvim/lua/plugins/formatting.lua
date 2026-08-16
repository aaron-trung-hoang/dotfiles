return {
  -- Format buffers through one interface, using the attached language server.
  -- Conform keeps format-on-save synchronous so the formatted text reaches disk.
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        mode = { "n", "x" },
        desc = "Format buffer or selection",
      },
      {
        "<leader>uf",
        function()
          vim.g.autoformat = not vim.g.autoformat
          vim.notify("Auto format " .. (vim.g.autoformat and "enabled" or "disabled"))
        end,
        desc = "Toggle auto format",
      },
    },
    opts = {
      -- Manual formatting and format-on-save share these LSP fallback defaults.
      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
      format_on_save = function(bufnr)
        if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
          return
        end
        return {}
      end,
    },
    init = function()
      -- Make gq use the same formatter selection for motions and selections.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
