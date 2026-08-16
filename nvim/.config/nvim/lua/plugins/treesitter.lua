local parsers = {
  "bash",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  -- Parse source code into a syntax tree so Neovim can highlight by meaning
  -- and understand code structure. Parsers are limited to the languages used
  -- by this config; JavaScript/TypeScript are omitted.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.setup({})
      treesitter.install(parsers)

      -- The Bash parser understands the shell files in this repository.
      -- Reuse it for sh and zsh because neither has a separate installed parser.
      vim.treesitter.language.register("bash", { "sh", "zsh" })

      -- Start Tree-sitter only for installed parsers. Unsupported file types
      -- keep Neovim's normal syntax highlighting instead of raising an error.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true }),
        callback = function(event)
          local language = vim.treesitter.language.get_lang(event.match)
          if language and pcall(vim.treesitter.start, event.buf, language) then
            -- Use syntax nodes for folds while keeping them open initially.
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
        end,
      })
    end,
  },
}
