# Neovim configuration guide

## Direction

- Keep this configuration explicit and understandable. It should provide a
  LazyVim-like experience without importing `LazyVim/LazyVim` or copying the
  starter configuration wholesale.
- Add plugins as direct lazy.nvim specifications under `lua/plugins/`.
- Add only language support that is actually needed. Do not add JavaScript or
  TypeScript tooling unless the user requests it.
- Preserve Catppuccin and the existing navigation configuration unless the user
  asks to change them.
- Write comments that explain how a setting is used or why it exists. One line
  is enough for simple behavior; use two or three lines for complex behavior.

## Language tooling

Language support is an explicit allowlist. Selecting a tool is explicit, while
stable implementation details such as commands, root detection, default
arguments, and output parsers should continue to come from the relevant plugin.

| Language | LSP | Formatter | Standalone linter |
| --- | --- | --- | --- |
| Go | `gopls` | LSP fallback | None - use LSP diagnostics |
| Shell | `bashls` | LSP fallback via `shfmt` | None |
| Lua | `lua_ls` | LSP fallback | None - use LSP diagnostics |
| Terraform | `terraformls` | LSP fallback | None - use LSP diagnostics |
| TOML | `taplo` | LSP fallback | None - use LSP diagnostics |
| YAML | `yamlls` | LSP fallback | None - use LSP diagnostics |

### LSP and Mason

- `lua/plugins/lsp.lua` owns the `servers` allowlist. Adding a server there
  makes Mason install it and Neovim configure and enable it.
- Keep `automatic_enable = false`. A package installed manually through Mason
  must not silently become an enabled language server.
- Put non-LSP tools managed by Mason in the local `tools` list. Server-specific
  settings belong beside that server in `servers`.
- Use `nvim-lspconfig` defaults unless there is a concrete reason to override a
  server command, root detector, filetype, or setting.

### Formatting

- `lua/plugins/formatting.lua` owns Conform configuration.
- Prefer formatting through the attached language server. When a server delegates
  to an external executable, keep that tool in `tools` in `lsp.lua` so Mason
  installs it reproducibly.
- Add a Conform filetype route only when a dedicated formatter is concretely
  better than the language server's formatting support.
- Preserve the global and buffer-local `autoformat` toggles and make manual and
  format-on-save behavior use the same formatter selection.

### Linting

- No standalone linter plugin is configured. Prefer language-server diagnostics
  unless a separate linter provides concrete additional value.
- Bash LS has its ShellCheck integration explicitly disabled. ShellCheck remains
  a repository verification tool installed by the macOS Brewfile.

## Adding a language

1. Decide separately whether the language needs an LSP server, formatter,
   standalone linter, and Tree-sitter parser. Do not assume it needs all four.
2. Add the server and only necessary overrides to `servers` in `lsp.lua`.
3. Add external Mason-managed tools to `tools` in `lsp.lua`.
4. Add formatter or linter routes only when separate tools are necessary.
5. Add only necessary Tree-sitter parsers in `treesitter.lua`.
6. Sync lazy.nvim when plugins change and keep `lazy-lock.json` updated.
7. Update this matrix when the supported language set changes.

## Verification

- Test behavior through Neovim, not only by requiring Lua modules. For LSP,
  formatting, or linting changes, open a representative buffer and verify the
  end-user action or autocmd produces the expected result.
- Run `nvim --headless +qa` to catch startup errors.
- Run StyLua against changed Lua files and `git diff --check` before finishing.
- Run ShellCheck against changed shell scripts.
- Confirm Mason contains only explicitly allowlisted packages after changing
  servers or tools.
