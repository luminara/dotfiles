local wezterm = require("wezterm")
local config = wezterm.config_builder()

local appearance_themes = {
  Light = "Catppuccin Latte",
  Dark = "Catppuccin Mocha",
}

local appearance = wezterm.gui.get_appearance()
config.color_scheme = appearance_themes[appearance]

config.font = wezterm.font("MesloLGS Nerd Font Mono")

config.window_background_opacity = 0.9

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
  options = {
    icons_enabled = true,
    theme = appearance_themes[appearance],
    tabs_enabled = true,
  },
  sections = {
    tabline_a = {},
    tabline_b = {},
    tabline_c = {},
    tabline_x = {},
    tabline_y = {},
    tabline_z = {},
  },
  extensions = {},
})

tabline.apply_to_config(config)

config.window_decorations = "NONE"

return config
