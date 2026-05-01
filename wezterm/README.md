# WezTerm Notes

This repo manages the WezTerm config at [`.wezterm.lua`](./.wezterm.lua).

## Current setup in this repo

The current config is intentionally visual and minimal:

- Background image: `~/.background-wezterm/terminal.jpg`
- Very dark image transform: `brightness = 0.03`
- Slight transparency: `window_background_opacity = 0.90`
- Strong macOS blur: `macos_window_background_blur = 85`
- No title bar, but still resizable: `window_decorations = "RESIZE"`
- Tab bar enabled: `enable_tab_bar = true`
- Large default window: `170 x 50`
- Theme: `Tokyo Night`
- Font: `JetBrainsMono Nerd Font Mono`, `Medium`, `Expanded`, size `15`

Because `window_decorations = "RESIZE"` removes the native title bar, the tab bar becomes the main visible top chrome. You can still resize the window, and the tab bar is the most natural place to drag the window around.

## Key naming on macOS

WezTerm docs use cross-platform names:

- `SUPER` or `CMD`: the `Command` key on macOS
- `ALT` or `OPT`: the `Option` key on macOS
- `CTRL`: the `Control` key

## Mental model

WezTerm is organized like this:

- A `window` contains one or more `tabs`
- A `tab` contains one or more `panes`
- A `pane` is one terminal area/process inside a tab

When the docs say `CurrentPaneDomain`, it means "open the new tab or pane in the same backend/session as the currently focused pane." In this repo, with no custom SSH/WSL/unix domains configured, that usually just means "open it locally on this Mac."

## Windows on macOS

- New window: `Cmd+n`
- Hide WezTerm: `Cmd+m`
- Toggle fullscreen: `Option+Enter`
- Close the window: close the last remaining tab, or use the macOS window controls

This config does not define a custom "close window" keybinding. In practice, `Cmd+w` closes the current tab, and if that was the last tab, the window closes too.

## Tabs on macOS

- New tab: `Cmd+t`
- New tab in the current pane domain: `Cmd+t`
- Close current tab: `Cmd+w`
- Go to tab 1 through 8: `Cmd+1` through `Cmd+8`
- Go to the last tab: `Cmd+9`
- Previous tab: `Cmd+Shift+[`
- Next tab: `Cmd+Shift+]`

There are also non-macOS-style alternatives that still work:

- Previous tab: `Ctrl+Shift+Tab` or `Ctrl+PageUp`
- Next tab: `Ctrl+Tab` or `Ctrl+PageDown`
- Move current tab left: `Ctrl+Shift+PageUp`
- Move current tab right: `Ctrl+Shift+PageDown`

## Panes on macOS

WezTerm supports split panes inside a tab.

- Split vertically: `Ctrl+Option+Shift+'`
- Split horizontally: `Ctrl+Option+Shift+5`
- Move focus to the pane on the left: `Ctrl+Shift+LeftArrow`
- Move focus to the pane on the right: `Ctrl+Shift+RightArrow`
- Move focus to the pane above: `Ctrl+Shift+UpArrow`
- Move focus to the pane below: `Ctrl+Shift+DownArrow`
- Resize the active pane left: `Ctrl+Option+Shift+LeftArrow`
- Resize the active pane right: `Ctrl+Option+Shift+RightArrow`
- Resize the active pane up: `Ctrl+Option+Shift+UpArrow`
- Resize the active pane down: `Ctrl+Option+Shift+DownArrow`
- Zoom or unzoom the active pane: `Ctrl+Shift+z`

Notes:

- In the WezTerm docs, the default split keys are shown as `Ctrl+Shift+Alt+"` and `Ctrl+Shift+Alt+%`.
- On this Mac, `wezterm show-keys` also reports the practical physical-key forms `Ctrl+Option+Shift+'` and `Ctrl+Option+Shift+5`, which are often easier to follow on macOS keyboards.

## Closing or deleting a pane

There is no dedicated default "close current pane" shortcut in this repo's current setup.

The normal ways to remove a pane are:

- Exit the shell running in that pane with `exit`
- Send EOF with `Ctrl+d`
- Quit the foreground program running in that pane

If that pane's process exits, WezTerm will usually close that pane automatically.

If you want a true "kill this pane now" shortcut, you can add a custom `CloseCurrentPane` binding later.

## Live inspection

To see the effective keybindings for the installed WezTerm version on this machine:

```bash
wezterm show-keys
```

Useful filters:

```bash
wezterm show-keys | rg 'Tab|Pane|Split|Close|Activate'
```

## References

- [WezTerm configuration](https://wezterm.org/config/files.html)
- [Default key assignments](https://wezterm.org/config/default-keys.html)
- [Key bindings](https://wezterm.org/config/keys.html)
- [Multiplexing and domains](https://wezterm.org/multiplexing.html)
- [Split pane action](https://wezterm.org/config/lua/keyassignment/SplitPane.html)
- [Close current pane](https://wezterm.org/config/lua/keyassignment/CloseCurrentPane.html)
