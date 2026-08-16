-- Leader keys prefix custom and plugin mappings.
vim.g.mapleader = " " -- Global leader key
vim.g.maplocalleader = "\\" -- Local leader key
vim.g.autoformat = true -- Format on save with Conform; toggle with leader-u-f
vim.g.snacks_animate = true -- Allow Snacks modules to animate UI transitions

local opt = vim.opt -- Short option accessor

-- Editing and completion behavior.
opt.autowrite = true -- Write files automatically
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Use the system clipboard locally
opt.completeopt = { "menu", "menuone", "noselect" } -- Show completion without selecting an item
opt.conceallevel = 2 -- Hide Markdown emphasis markers and similar syntax
opt.confirm = true -- Confirm unsaved operations
opt.cursorline = true -- Highlight the current line
opt.expandtab = true -- Use spaces instead of tabs

-- Folds, search, and command behavior.
opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", diff = "╱", eob = " " } -- Set fold/diff glyphs and hide end-of-buffer tildes
opt.foldlevel = 99 -- Start with folds open
opt.foldmethod = "indent" -- Fold by indentation initially
opt.foldtext = "" -- Use virtual fold text
opt.formatoptions = "jcroqlnt" -- Preserve comments and make gq formatting predictable
opt.grepformat = "%f:%l:%c:%m" -- Parse ripgrep results
opt.grepprg = "rg --vimgrep" -- Use ripgrep
opt.ignorecase = true -- Ignore case in searches
opt.inccommand = "nosplit" -- Preview substitutions inline
opt.jumpoptions = "view" -- Restore folds and cursor view when jumping back

-- Window and interface behavior.
opt.cmdheight = 0 -- Hide the command row until a command or message needs it
opt.laststatus = 3 -- Use a global status line
opt.linebreak = true -- Wrap at convenient points
opt.list = true -- Show selected invisible characters
opt.mouse = "a" -- Enable mouse support
opt.number = true -- Show line numbers
opt.pumblend = 10 -- Blend completion popups
opt.pumheight = 10 -- Limit completion menu height
opt.relativenumber = true -- Show relative line numbers
opt.ruler = false -- Hide the default ruler
opt.scrolloff = 4 -- Keep context around the cursor

-- Indentation and display details.
opt.shiftround = true -- Round indentation to shift width
opt.shiftwidth = 2 -- Indent by two spaces
opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- Hide routine write and completion messages
opt.showmode = false -- Hide the current mode
opt.sidescrolloff = 8 -- Keep horizontal cursor context
opt.signcolumn = "yes" -- Always show the sign column
opt.smartcase = true -- Match case when uppercase is used
opt.smartindent = true -- Insert indentation automatically
opt.smoothscroll = true -- Scroll wrapped lines smoothly
opt.spelllang = { "en" } -- Use English spell checking
opt.splitbelow = true -- Open horizontal splits below
opt.splitkeep = "screen" -- Avoid visible text jumps when resizing splits
opt.splitright = true -- Open vertical splits to the right
opt.tabstop = 2 -- Display tabs as two spaces

-- Timing, undo, and terminal behavior.
opt.termguicolors = true -- Enable true color support
opt.timeoutlen = 300 -- Set mapping timeout
opt.undofile = true -- Persist undo history
opt.undolevels = 10000 -- Retain extensive undo history
opt.updatetime = 200 -- Reduce update delay
opt.virtualedit = "block" -- Let visual block selection move past line endings
opt.wildmode = "longest:full,full" -- Configure command completion
opt.winminwidth = 5 -- Keep windows usable
opt.wrap = false -- Disable line wrapping by default

vim.g.markdown_recommended_style = 0 -- Preserve configured indentation
