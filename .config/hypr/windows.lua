hl.window_rule({
  match = { title = "PenTablet" },
  no_focus = true,
})

hl.window_rule({
  match = { title = "Pentablet" },
  workspace = "6 silent",
})

hl.window_rule({
  match = { title = MusicPlayer },
  workspace = "3",
})

hl.window_rule({
  match = { class = "Vncviewer" },
  workspace = "5",
})

hl.window_rule({
  match = { class = "blueman-manager" },
  workspace = "special:minimized",
})
