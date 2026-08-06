-- Volume / brightness (repeating)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 +2%"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 -2%"), { repeating = true })

hl.bind(MainMod .. " + equal", hl.dsp.exec_cmd("pactl set-sink-volume 0 +2%"), { repeating = true })
hl.bind(MainMod .. " + minus", hl.dsp.exec_cmd("pactl set-sink-volume 0 -2%"), { repeating = true })

hl.bind(MacroMod .. " + equal", hl.dsp.exec_cmd("bash ~/scripts/rtaudio.sh up"), { repeating = true })
hl.bind(MacroMod .. " + minus", hl.dsp.exec_cmd("bash ~/scripts/rtaudio.sh down"), { repeating = true })

-- Media / audio keys (locked so they work on lock screen)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute 0 toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute 0 toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true })

-- Apps
hl.bind(MainMod .. " + return", hl.dsp.exec_cmd(Terminal))
hl.bind(MainMod .. " + E", hl.dsp.exec_cmd(FileManager))
hl.bind(MainMod .. " + SHIFT + E", hl.dsp.exec_cmd(Terminal .. " start " .. TuiFileManager))
hl.bind(MainMod .. " + T", hl.dsp.exec_cmd(TextEditor))
hl.bind(MainMod .. " + space", hl.dsp.exec_cmd(Menu))
hl.bind(MainMod .. " + P", hl.dsp.exec_cmd("hyprkcs"))
hl.bind(MainMod .. " + B", hl.dsp.exec_cmd("blueman-manager"))

-- Window management
hl.bind(MainMod .. " + C", hl.dsp.window.close())
hl.bind(MainMod .. " + DELETE", hl.dsp.exit())
hl.bind(MainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -z -m region"))
hl.bind("CONTROL + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m output -m active"))

-- Lock
hl.bind(MacroMod .. " + CONTROL + l", hl.dsp.exec_cmd("hyprlock"))

hl.bind("CONTROL + SHIFT + Q", hl.dsp.exec_cmd("bash ~/scripts/dismount_veracrypt.sh"))

-- Toggle Waybar / Hyprsunset
hl.bind(MainMod .. " + W", hl.dsp.exec_cmd([[bash -c "pgrep waybar && pkill waybar || waybar"]]))
hl.bind(MainMod .. " + S", hl.dsp.exec_cmd([[bash -c "pgrep hyprsunset && pkill hyprsunset || hyprsunset"]]))
hl.bind(MainMod .. " + comma", hl.dsp.exec_cmd("swaync-client -t"))

-- Toggle WiFi (Numpad 0 = KP_Insert)
hl.bind(MainMod .. " + KP_Insert",
  hl.dsp.exec_cmd([[bash -c "nmcli radio wifi $(nmcli radio wifi | grep -q enabled && echo off || echo on)"]]))

-- XP Pen tablet config (Numpad 1/2/3 = KP_End/KP_Down/KP_Next)
hl.bind(MainMod .. " + KP_End", hl.dsp.exec_cmd(ChangeConf .. " " .. ConfDir .. "/krita.pcfg"))
hl.bind(MainMod .. " + KP_Down", hl.dsp.exec_cmd(ChangeConf .. " " .. ConfDir .. "/osu.pcfg"))
hl.bind(MainMod .. " + KP_Next", hl.dsp.exec_cmd(ChangeConf .. " " .. ConfDir .. "/chess.pcfg"))

-- Send arrow keys to focused app (vim-style with macroMod)
hl.bind(MacroMod .. " + H", hl.dsp.send_shortcut({ mods = "", key = "left" }))
hl.bind(MacroMod .. " + L", hl.dsp.send_shortcut({ mods = "", key = "right" }))
hl.bind(MacroMod .. " + K", hl.dsp.send_shortcut({ mods = "", key = "up" }))
hl.bind(MacroMod .. " + J", hl.dsp.send_shortcut({ mods = "", key = "down" }))

-- Focus movement (vim-style)
hl.bind(MainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(MainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(MainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(MainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Move windows (repeating)
hl.bind(MainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { repeating = true })
hl.bind(MainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { repeating = true })
hl.bind(MainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind(MainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { repeating = true })

-- Mouse drag / resize
hl.bind(MainMod .. " + Z", hl.dsp.window.drag(), { mouse = true })
hl.bind(MainMod .. " + X", hl.dsp.window.resize(), { mouse = true })
hl.bind(MainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspace navigation
hl.bind(MacroMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Resize active window (repeating)
hl.bind(MainMod .. " + CONTROL + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(MainMod .. " + CONTROL + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(MainMod .. " + CONTROL + K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(MainMod .. " + CONTROL + J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

-- Fullscreen modes
hl.bind(MainMod .. " + F", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(MainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 0 }))

-- Session / scripts
hl.bind(MainMod .. " + BACKSPACE", hl.dsp.exec_cmd("bash ~/scripts/leave.sh"))
hl.bind(MainMod .. " + D", hl.dsp.exec_cmd("bash ~/scripts/DarkLight.sh"))
hl.bind(MainMod .. " + SHIFT + D", hl.dsp.exec_cmd("bash ~/scripts/WallpaperSelect.sh"))

-- Pypr scratchpads
hl.bind(MainMod .. " + A", hl.dsp.exec_cmd("pypr toggle notes"))
hl.bind(MainMod .. " + M", hl.dsp.exec_cmd("pypr toggle element"))
hl.bind(MainMod .. " + R",
  hl.dsp.exec_cmd("bash -c 'pgrep -f " .. MusicPlayer .. " && pypr toggle fum || " .. MusicPlayer .. "'"))

-- Special workspace (minimise scratchpad)
hl.bind(MainMod .. " + N", hl.dsp.workspace.toggle_special("minimized"))
hl.bind(MainMod .. " + SHIFT + N", hl.dsp.window.move({ workspace = "special:minimized" }))

-- Lid switch → lock
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprlock"), { locked = true })

-- Submaps
hl.bind(MainMod .. " + F5", hl.dsp.submap("restricted"))
hl.bind("F5", hl.dsp.submap("reset"))
