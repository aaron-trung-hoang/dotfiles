return {
  -- Format buffers through one interface, using a dedicated formatter when
  -- configured and the attached LSP only as a fallback. Conform also keeps
  -- format-on-save synchronous so the formatted text is what reaches disk.
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
      -- Manual formatting and format-on-save share these defaults.
      -- YAML has no extra formatter, so it falls back to yamlls here.
      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        bash = { "shfmt" },
        lua = { "stylua" },
        sh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
          return
        end
        return {}
      end,
      formatters = {
        -- Match the two-space indentation configured in options.lua.
        -- Conform already reads shiftwidth for shfmt; -ci also indents case bodies.
        shfmt = { append_args = { "-ci" } },
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
      },
    },
    init = function()
      -- Make gq use the same formatter selection for motions and selections.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
