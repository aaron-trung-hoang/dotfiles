# VS Code navigation and search

The VS Code user settings and keybindings are symlinked to this directory.
Changes here take effect in VS Code. Language tooling is configured separately.

Space is the Vim leader. Leader sequences apply in normal editor mode, so they
do not interfere with typing in insert mode, search inputs, or terminals.

| Keys | Action |
| --- | --- |
| `H` / `L` | Previous / next editor |
| `Space bb` | Previously used editor |
| `Space bd` / `Space bo` | Close editor / other editors in the current group |
| `Ctrl+h/j/k/l` | Focus left / below / above / right editor group |
| `Space -` / `Space \|` | Split below / right |
| `Space wd` | Close editor group |
| `Ctrl+Up/Down` | Increase / decrease group height |
| `Ctrl+Left/Right` | Decrease / increase group width |
| `Space Space`, `Space ff`, `Space fF` | Find workspace files |
| `Space /`, `Space sg` | Search workspace text in Quick Search |
| `Space sr` | Search and replace across files |
| `Space fb` | List open editors |
| `Space fr`, `Space fp` | Recently opened files, folders, and workspaces |
| `Space fe`, `Space fE` | Focus the Explorer |
| `gd` / `gy` | Definition / type definition |

Inside pickers, `Ctrl+j/n` moves down and `Ctrl+k/p` moves up. Enter opens the
selected result. Escape cancels the picker and restores the previous editor
view. Native Vim `/`, `?`, `n`, and `N` still search within the current file.

## Search scope and matching

Open the project directory as a VS Code folder to make workspace search match
the usual Neovim project search. VS Code has no independent Neovim-style working
directory or nearest-Git-root picker scope: the project and cwd bindings are
workspace aliases. A workspace with multiple folders searches all those folders.

File search accepts directory segments such as `src/deep/navigation`. Quick
Search displays matching lines and previews the selected match in the editor.
Search includes dotfiles, respects local, parent, and global ignore files, and
does not follow symlinks. Git metadata stays excluded; text search also excludes
`.bare`. Extra default search exclusions are disabled so unignored files remain
searchable. Workspace settings can override these user settings.

Text search uses smart case: lowercase queries ignore case, while uppercase
queries match case. Quick Search starts with an empty query and uses literal
matching. For regular expressions, use the full Search view (`Cmd+Shift+f` on
macOS) and enable its regex button. Unlike Snacks grep, Quick Search caps its
display at 30 files and 10 matches per file; use its Search view button for the
remaining results. File ranking and the picker layout remain VS Code's own.

Recent items include folders and workspaces as well as files. `Space bo` acts on
the current editor group; Neovim's buffer operation has a broader scope.

## Shortcut collisions

Checked against the installed VS Code defaults, VSCodeVim bindings, and macOS
symbolic shortcuts on 2026-10-10.

- `Ctrl+h/j/k/l` overlap VS Code text editing and VSCodeVim commands. User
  bindings override them only when a Vim editor is in normal mode.
- `Ctrl+arrows` overlap VSCodeVim movement. User bindings resize only in normal
  editor mode, leaving picker navigation and insert mode alone.
- Plain macOS `Ctrl+Up/Down/Left/Right` Mission Control and Spaces shortcuts are
  currently disabled. Enabling them later would intercept split resizing.
- `Ctrl+Space` input-source switching and `Cmd+Space` Spotlight are enabled.
  Neither overlaps sequential Space leader keys.
- Picker `Ctrl+k` overrides VS Code's delete-to-end-of-line action only in quick
  pickers. `Ctrl+j/n/p` are also scoped to those pickers.
- The old global Explorer `Ctrl+e` and multi-cursor `Ctrl+n` overrides were
  removed. Vim scrolling and completion can use those keys again. On macOS,
  multi-cursor selection uses the standard `Cmd+d` shortcut.
- The old `Space w` save mapping was removed because it was a shorter prefix
  of `Space wd`. Save with the existing native `Cmd+s` shortcut or `:w`.

Normal-mode navigation lives in `vim.normalModeKeyBindingsNonRecursive` in
`settings.json`. Modified keys that collide with editor or extension defaults
live in `keybindings.json` with explicit focus and mode conditions. This follows
VS Code's user-binding precedence without removing defaults globally.
