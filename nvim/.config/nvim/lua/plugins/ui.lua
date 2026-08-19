-- Prefer the nearest Git root for project actions and fall back to the current
-- working directory when the buffer is outside a repository.
local function project_root()
  return vim.fs.root(0, { ".git" }) or vim.uv.cwd()
end

return {
  -- Snacks supplies the dashboard plus several coordinated UI modules.
  -- Start with leader-space for files, leader-slash for grep, leader-f-e for
  -- the explorer, or leader-f-t for a project terminal.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true }, -- Reduce expensive features for very large files.
      dashboard = {
        enabled = true,
        -- Keep startup focused on common actions. Less frequent commands remain
        -- available through their normal mappings or command-line commands.
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
        preset = {
          header = [[
 █████╗  █████╗ ██████╗  ██████╗ ███╗   ██╗
██╔══██╗██╔══██╗██╔══██╗██╔═══██╗████╗  ██║
███████║███████║██████╔╝██║   ██║██╔██╗ ██║
██╔══██║██╔══██║██╔══██╗██║   ██║██║╚██╗██║
██║  ██║██║  ██║██║  ██║╚██████╔╝██║ ╚████║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝]],
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find file",
              action = function()
                Snacks.picker.files()
              end,
            },
            { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "Find text",
              action = function()
                Snacks.picker.grep()
              end,
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent files",
              action = function()
                Snacks.picker.recent()
              end,
            },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      explorer = { enabled = true }, -- Browse and edit the project tree.
      indent = { enabled = true }, -- Draw indentation guides and current scope.
      picker = {
        enabled = true,
        sources = {
          grep = { hidden = true },
        },
      }, -- Search files, text inside hidden files, buffers, Git, and history.
      scroll = { enabled = true }, -- Animate larger scroll movements.
      -- Use a bordered floating window instead of the default bottom split.
      -- The fixed title replaces Snacks' generated "1: shell@path" winbar.
      terminal = {
        enabled = true,
        -- Interactive shells may keep a nonzero status after Ctrl-C. Close the
        -- terminal quietly when the user exits instead of reporting that status.
        auto_close = false,
        win = {
          position = "float",
          border = "rounded",
          title = " Terminal ",
          title_pos = "center",
          width = 0.85,
          height = 0.8,
          on_buf = function(window)
            vim.api.nvim_create_autocmd("TermClose", {
              buffer = window.buf,
              once = true,
              callback = function()
                vim.schedule(function()
                  if window:buf_valid() then
                    window:close()
                  end
                end)
              end,
            })
          end,
        },
      },
      words = { enabled = true }, -- Highlight and navigate symbol references.
    },
    keys = {
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep project",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command history",
      },
      {
        "<leader><space>",
        function()
          Snacks.picker.files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find config file",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files({ cwd = project_root() })
        end,
        desc = "Find files in project",
      },
      {
        "<leader>fF",
        function()
          Snacks.picker.files({ cwd = vim.uv.cwd() })
        end,
        desc = "Find files in cwd",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent files",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>fe",
        function()
          Snacks.explorer({ cwd = project_root() })
        end,
        desc = "Explorer project",
      },
      {
        "<leader>fE",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer cwd",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Scratch buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select scratch buffer",
      },
      {
        "<leader>ft",
        function()
          Snacks.terminal(nil, { cwd = project_root() })
        end,
        desc = "Terminal project",
      },
    },
  },
  -- Visualize persistent undo history and switch between divergent edit branches.
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
    },
  },
  -- Render Markdown structure in normal mode and restore raw punctuation while editing.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    opts = {
      html = { enabled = false }, -- No HTML parser is installed.
      latex = { enabled = false }, -- No LaTeX parser or converter is installed.
      win_options = {
        conceallevel = {
          default = 0,
          rendered = 3,
        },
      },
    },
  },
  -- Replace Neovim's plain status line with only the current mode and file path.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
  -- Supply icons to Snacks and other UI plugins.
  -- The compatibility shim satisfies plugins that expect nvim-web-devicons
  -- without installing a second icon provider.
  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      processor = "magick_cli",
    },
  }
}
