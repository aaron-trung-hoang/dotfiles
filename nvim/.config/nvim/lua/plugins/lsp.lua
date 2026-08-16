-- This table is the single allowlist for language servers.
-- Adding a name here makes Mason install it and Neovim configure and enable it.
local servers = {
  bashls = {
    settings = {
      bashIde = {
        -- Keep shell diagnostics lightweight instead of invoking standalone ShellCheck.
        shellcheckPath = "",
        -- Bash LS delegates LSP formatting to shfmt; preserve case-body indentation.
        shfmt = { caseIndent = true },
      },
    },
  },
  gopls = {},
  lua_ls = {
    settings = {
      Lua = {
        -- Insert a function call as one editable snippet instead of nesting brackets.
        completion = { callSnippet = "Replace" },
        -- LazyDev supplies Neovim and plugin types, so no third-party prompt is needed.
        workspace = { checkThirdParty = false },
      },
    },
  },
  taplo = {},
  terraformls = {},
  -- Support regular YAML without registering unused Docker, GitLab, or Helm types.
  yamlls = { filetypes = { "yaml" } },
}

local server_names = vim.tbl_keys(servers)
table.sort(server_names)

-- Bash LS delegates document formatting to this external executable.
local tools = { "shfmt" }

return {
  -- Install external editor tools under Neovim's data directory.
  -- Open leader-c-m to see package status, logs, updates, or manual installs.
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)

      -- Refresh the registry before resolving packages on a new machine.
      -- Existing tools are left untouched; missing allowlisted tools are installed.
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(tools) do
          local package = registry.get_package(name)
          if not package:is_installed() then
            package:install()
          end
        end
      end)
    end,
  },

  -- Translate lspconfig names such as lua_ls to Mason package names.
  -- Only the allowlisted servers are installed; manually installed servers stay disabled.
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = server_names,
      automatic_enable = false,
    },
  },

  -- Provide maintained defaults for each server to Neovim's native LSP client.
  -- Blink capabilities let servers return richer completion items and snippets.
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      -- Diagnostics remain visible while typing without changing underneath the cursor.
      -- Use [d/]d to navigate and leader-c-d to inspect the current line.
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many" },
        float = { border = "rounded", source = true },
      })

      -- These familiar mappings are added only where a language server attaches.
      -- Neovim also provides K, grr, gri, grn, and gra for other LSP actions.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("dotfiles_lsp_attach", { clear = true }),
        callback = function(event)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Goto definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
          map("n", "gy", vim.lsp.buf.type_definition, "Goto type definition")
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP information")
        end,
      })
    end,
  },
}
