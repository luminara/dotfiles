#!/bin/bash

## /* ----  Dark/Light Switcher  ---- */ ##

# Arguments:
# $1 = Wallpaper Filename (Optional - leave empty for random)
# $2 = Mode (Optional - leave empty to auto-toggle)

ARG_WALLPAPER="$1"
ARG_MODE="$2"

# Paths
wallpaper_base_path="$HOME/wallpapers"
dark_wallpapers="$wallpaper_base_path/Dark"
light_wallpapers="$wallpaper_base_path/Light"

# ── 1. Determine Wallpaper ────────────────────────────────────────────────────

if [[ -n "$ARG_WALLPAPER" ]]; then
  next_wallpaper=$(find -L "$wallpaper_base_path" -type f -name "$ARG_WALLPAPER" | head -n1)
  if [[ -z "$next_wallpaper" ]]; then
    notify-send "Error" "Wallpaper '$ARG_WALLPAPER' not found under $wallpaper_base_path"
    exit 1
  fi

  if [[ "$next_wallpaper" == "$dark_wallpapers"* ]]; then
    next_mode="Dark"
  elif [[ "$next_wallpaper" == "$light_wallpapers"* ]]; then
    next_mode="Light"
  else
    CURRENT_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)
    if [[ "$CURRENT_SCHEME" == "'prefer-light'" ]]; then
      next_mode="Dark"
    else
      next_mode="Light"
    fi
  fi

else

  CURRENT_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)

  if [[ -n "$ARG_MODE" ]]; then
    next_mode="$ARG_MODE"
  else
    if [[ "$CURRENT_SCHEME" == "'prefer-light'" ]]; then
      next_mode="Dark"
    else
      next_mode="Light"
    fi
  fi

  if [[ "$next_mode" == "Dark" ]]; then
    wallpaper_dir="$dark_wallpapers"
  else
    wallpaper_dir="$light_wallpapers"
  fi

  next_wallpaper=$(find -L "$wallpaper_dir" -type f \
    \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n1)

fi

if [[ -z "$next_wallpaper" ]]; then
  notify-send "Error" "No wallpapers found"
  exit 1
fi

if [[ "$next_mode" == "Dark" ]]; then
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
else
  gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
fi

notify-send -u low "Theme Switch" \
  "Mode: $next_mode | Wallpaper: $(basename "$next_wallpaper")"

matugen image "$next_wallpaper" --mode "${next_mode,,}"
pkill -SIGUSR1 nvim || true
hyprctl hyprpaper wallpaper , "$next_wallpaper"

exit 0
