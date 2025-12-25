#!/bin/bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For Dark and Light switching

# Paths
wallpaper_base_path="$HOME/wallpapers"
dark_wallpapers="$wallpaper_base_path/Dark"
light_wallpapers="$wallpaper_base_path/Light"

# Determine current theme mode
if [ "$(gsettings get org.gnome.desktop.interface color-scheme)" = "'prefer-light'" ]; then
    next_mode="Dark"
    # Logic for Dark mode
    wallpaper_path="$dark_wallpapers"
else
    next_mode="Light"
    # Logic for Light mode
    wallpaper_path="$light_wallpapers"
fi

# Function to notify user
notify_user() {
    notify-send -u low -i "$notif" " Switching to" " $1 mode"
}


if [ "$next_mode" = "Dark" ]; then
    next_wallpaper="$(find -L "${dark_wallpapers}" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | shuf -n1 -z | xargs -0)"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
else
    next_wallpaper="$(find -L "${light_wallpapers}" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | shuf -n1 -z | xargs -0)"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
fi

# Update wallpaper 
notify_user "$next_mode"
cp "$next_wallpaper" "$wallpaper_base_path/DynamicWallpaper"
pgrep hyprpaper && pkill hyprpaper || sleep 1 && hyprpaper &

exit 0
