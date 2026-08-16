return {
  -- Open an interactive project-wide search and replace UI with leader-s-r.
  -- When started from a file, prefill its extension as the initial file filter.
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          local extension = vim.bo.buftype == "" and vim.fn.expand("%:e")
          require("grug-far").open({
            transient = true,
            prefills = { filesFilter = extension ~= "" and "*." .. extension or nil },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and replace",
      },
    },
  },
  -- Press s to label visible matches, then type a label to jump there.
  -- Use S for Treesitter selections and operator-mode r for remote operations.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter search",
      },
      {
        "<C-s>",
        mode = "c",
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash search",
      },
    },
  },
  -- Display valid continuations after prefixes such as leader, g, [ or ].
  -- Press leader-? for mappings local to the current buffer.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "previous" },
        { "]", group = "next" },
        { "g", group = "goto" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps",
      },
      {
        "<C-w><space>",
        function()
          require("which-key").show({ keys = "<C-w>", loop = true })
        end,
        desc = "Window mode",
      },
    },
  },
  -- Mark added, changed, and deleted lines in the sign column.
  -- Use ]h/[h to move between hunks, leader-g-h-p to preview, and
  -- leader-g-h-s or leader-g-h-r to stage or reset the selected hunk.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gitsigns = require("gitsigns")
        local function bind(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, silent = true, desc = desc })
        end

        bind("n", "]h", function()
          gitsigns.nav_hunk("next")
        end, "Next hunk")
        bind("n", "[h", function()
          gitsigns.nav_hunk("prev")
        end, "Previous hunk")
        bind({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
        bind({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
        bind("n", "<leader>ghS", gitsigns.stage_buffer, "Stage buffer")
        bind("n", "<leader>ghu", gitsigns.undo_stage_hunk, "Undo stage hunk")
        bind("n", "<leader>ghR", gitsigns.reset_buffer, "Reset buffer")
        bind("n", "<leader>ghp", gitsigns.preview_hunk_inline, "Preview hunk")
        bind("n", "<leader>ghb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame line")
        bind("n", "<leader>ghB", gitsigns.blame, "Blame buffer")
        bind("n", "<leader>ghd", gitsigns.diffthis, "Diff this")
        bind({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<cr>", "Select hunk")
      end,
    },
  },
  -- Present diagnostics, symbols, LSP results, and quickfix entries in one UI.
  -- Use leader-x-x for project diagnostics or leader-x-X for the current buffer.
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { modes = { lsp = { win = { position = "right" } } } },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
    },
  },
  -- Highlight TODO, FIXME, HACK, and similar annotations in source files.
  -- Jump with ]t/[t, search with leader-s-t, or list them through Trouble.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo",
      },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo list" },
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Search todos",
      },
    },
  },
}
