# How my NeoVim setup works

## Overview

```text

Neovim
│
├── lazy.nvim
│   └── installs/loads Neovim plugins
│
├── mason.nvim
│   └── installs external developer tools
│       ├── gopls
│       ├── lua_ls
│       ├── terraform-ls
│       ├── shfmt
│       └── ...
│
├── nvim-lspconfig
│   └── connects Neovim ↔ language servers
│       └── gives:
│           completion, diagnostics, hover,
│           go-to-definition, rename, etc.
│
├── mason-lspconfig.nvim
│   └── bridges Mason-installed LSPs
│       with nvim-lspconfig
│
├── nvim-treesitter
│   └── parses source-code syntax
│       → highlighting, folding, syntax-aware movement
│
├── blink.cmp
│   └── displays completion suggestions
│       mainly coming from LSP
│
├── conform.nvim
│   └── handles formatting
│       ├── standalone formatter: shfmt/gofmt/etc.
│       └── or LSP formatting when available
│
└── Other IDE/UI plugins
    ├── trouble → diagnostics/results UI
    ├── gitsigns → Git changes
    ├── grug-far → project search/replace
    ├── flash → navigation
    ├── which-key → keybinding hints
    └── snacks → picker/files/terminal/UI
```

## What happens when you open e.g. a Go file

```text
You open main.go
      │
      ├── Tree-sitter
      │     parses Go syntax
      │     → highlighting
      │     → folding
      │
      ├── nvim-lspconfig
      │     starts gopls
      │
      │       Neovim ← LSP → gopls
      │
      │       → diagnostics
      │       → go-to-definition
      │       → rename
      │       → hover
      │       → references
      │
      └── blink.cmp
            asks LSP:
            "Any completion suggestions here?"

            gopls returns:
            Println
            Printf
            Sprintf
            ...

            blink.cmp displays them
```
