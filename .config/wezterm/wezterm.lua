local wezterm = require("wezterm")
local config = wezterm.config_builder()

local theme_path = wezterm.home_dir .. "/.config/wezterm/colors/matugen_theme.toml"
config.color_scheme_dirs = { theme_path }
config.color_scheme = "matugen_theme"

config.font = wezterm.font("MesloLGS Nerd Font Mono")

config.window_background_opacity = 0.9

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

local scheme = wezterm.color.load_scheme(theme_path)
tabline.setup({
  options = {
    icons_enabled = true,
    theme = scheme,
    tabs_enabled = true,
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = {},
    tabline_c = {},
    tabline_x = {},
    tabline_y = {},
    tabline_z = {},
  },
  extensions = {},
})

tabline.apply_to_config(config)

config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.5cell',
  bottom = '0.5cell',
}

config.window_decorations = "NONE"

config.keys = {
  {
    key = 'a',
    mods = 'CTRL',
    action = wezterm.action.ActivateCopyMode
  }
}

return config
