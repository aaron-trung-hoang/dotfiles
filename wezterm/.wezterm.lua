local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()
local os = require("os")
local brightness = 0.03

-- image setting
local user_home = os.getenv("HOME")
config.window_background_image = user_home .. "/.background-wezterm/terminal.jpg"

config.window_background_image_hsb = {
    -- Darken the background image by reducing it
    brightness = brightness,
    hue = 1.0,
    saturation = 0.8,
}

-- window setting
config.window_background_opacity = 0.90
config.macos_window_background_blur = 85
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Fill the active display's macOS-managed usable area on startup. Maximizing,
-- rather than guessing pixel or cell dimensions, accounts for the menu bar,
-- Dock, display scaling, and the safe area below a MacBook notch.
wezterm.on("gui-startup", function(cmd)
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

config.color_scheme = "Tokyo Night"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium", stretch = "Expanded" })
config.font_size = 15

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

-- to enable shift + enter for new lines in codex, claude code
config.enable_kitty_keyboard = true

config.window_frame = {
    border_left_width = "0.28cell",
    border_right_width = "0.28cell",
    border_bottom_height = "0.15cell",
    border_top_height = "0.15cell",
    border_left_color = "pink",
    border_right_color = "pink",
    border_bottom_color = "pink",
    border_top_color = "pink",
}

-- others
config.cursor_thickness = 2

return config
