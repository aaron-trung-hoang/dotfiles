return {
  -- Apply Catppuccin Mocha at startup as the main editor theme.
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      term_colors = true,
      transparent_background = true, -- Let WezTerm's 90% opacity show through Neovim
      float = { transparent = true }, -- Match floating pickers and Explorer to the editor background
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
