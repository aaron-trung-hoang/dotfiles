-- Load core behavior before plugins so every plugin sees the same defaults.
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
