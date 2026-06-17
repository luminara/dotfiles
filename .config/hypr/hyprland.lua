require("vars")
require("keybinds")
require("workspaces")
require("windows")

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRSHOT_DIR", os.getenv("HOME") .. "/Pictures/Screenshots")

hl.config({
  general = {
    allow_tearing    = false,
    border_size      = 2,
    col              = {
      active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },
    gaps_in          = 1,
    gaps_out         = { top = 5, right = 4, bottom = 4, left = 4 },
    layout           = "dwindle",
    resize_on_border = false,
  },
  decoration = {
    active_opacity   = 1.0,
    inactive_opacity = 1.0,
    rounding         = 10,
    rounding_power   = 2,
    blur             = {
      enabled  = true,
      passes   = 1,
      size     = 3,
      vibrancy = 0.1696,
    },
    shadow           = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },
  },
  input = {
    follow_mouse       = 1,
    kb_layout          = "us",
    numlock_by_default = true,
    sensitivity        = 0,
    touchpad           = {
      natural_scroll = false,
    },
  },
  misc = {
    disable_hyprland_logo   = true,
    force_default_wallpaper = 0,
    middle_click_paste      = false,
  },
  master = {
    new_status = "master",
  },
  animations = {
    enabled = true,
  },
})

hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = "1",
})

hl.window_rule({ match = { fullscreen = true }, border_color = "rgb(00ff99)" })

hl.window_rule({
  name           = "suppress-maximize-events",
  match          = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name     = "fix-xwayland-drags",
  match    = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
})

hl.on("hyprland.start", function()
  hl.exec_cmd("waybar & hyprpaper & hypridle & swaync & hyprsunset")
  hl.exec_cmd("pypr --debug /tmp/pypr.log")
  hl.exec_cmd("[workspace 1 silent] " .. Terminal)
  hl.exec_cmd("[workspace 2] firefox")
  hl.exec_cmd("[workspace 6 silent] /usr/lib/pentablet/PenTablet.sh")
end)

hl.on("hyprland.start", function()
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
end)

hl.curve("myBeziner", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation = {
  { leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" },
  { leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" },
  { leaf = "border",      enabled = true, speed = 10, bezier = "default" },
  { leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" },
  { leaf = "fade",        enabled = true, speed = 7,  bezier = "default" },
  { leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" },
}
