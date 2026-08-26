-- Prefer the focused Explorer item, then the current buffer, and let Git
-- report a useful error when neither is part of a repository.
local function git_root()
  for _, explorer in ipairs(Snacks.picker.get({ source = "explorer" })) do
    if explorer:is_focused() then
      local item = explorer:current()
      local root = item and item.file and vim.fs.root(item.file, { ".git" })
      if root then
        return root
      end
    end
  end

  return vim.fs.root(0, { ".git" }) or vim.uv.cwd()
end

return {
  -- Label the Git and hunk key groups in which-key.
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
      })
    end,
  },

  -- Use Neogit for full repository operations while reusing the existing
  -- Snacks picker integration instead of installing another picker.
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      graph_style = "unicode",
      integrations = { snacks = true },
      kind = "tab",
      treesitter_diff_highlight = true,
    },
    keys = {
      {
        "<leader>gg",
        function()
          require("neogit").open({ cwd = git_root() })
        end,
        desc = "Neogit status",
      },
      {
        "<leader>gc",
        function()
          require("neogit").open({ "commit", cwd = git_root() })
        end,
        desc = "Neogit commit",
      },
    },
  },

  -- Use Snacks for lightweight repository pickers and remote browsing.
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git files",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git status",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git stash",
      },
      {
        "<leader>gd",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Git diff",
      },
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git log",
      },
      {
        "<leader>gb",
        function()
          Snacks.picker.git_log_line()
        end,
        desc = "Git blame line",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        mode = { "n", "x" },
        desc = "Git browse",
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
        bind({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", "Stage/unstage hunk")
        bind({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
        bind("n", "<leader>ghS", gitsigns.stage_buffer, "Stage buffer")
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
}
