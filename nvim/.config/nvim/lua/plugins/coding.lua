return {
  -- Insert matching brackets and quotes automatically while typing.
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  -- Add plugin type libraries only while editing Lua files.
  -- Lua LS then understands Snacks, lazy.nvim, and lspconfig APIs instead of
  -- reporting their modules and globals as unknown.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "lazy" } },
        { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
      },
    },
  },
  -- Open completion in insert mode and on the command line.
  -- Suggestions combine LSP results, paths, and words from open buffers.
  -- Use Ctrl-y to accept explicitly; command-line completion does not preselect.
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function()
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      },
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
    },
  },
}
