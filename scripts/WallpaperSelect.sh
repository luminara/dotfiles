#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers/"
IMAGE_PICKER_CONFIG="$HOME/.config/rofi/image-picker.rasi"
CURRENT_WALLPAPER_FILE="test.png"
ROFI_MENU=""

while IFS= read -r WALLPAPER_PATH; do
  [[ -z "$WALLPAPER_PATH" ]] && continue

  WALLPAPER_NAME=$(basename "$WALLPAPER_PATH")

  if [[ "$WALLPAPER_NAME" == "$CURRENT_WALLPAPER_FILE" ]]; then
    ROFI_MENU+="${WALLPAPER_NAME} (current)\0icon\x1f${WALLPAPER_PATH}\n"
  else
    ROFI_MENU+="${WALLPAPER_NAME}\0icon\x1f${WALLPAPER_PATH}\n"
  fi
done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

SELECTED_WALLPAPER=$(printf "%b" "$ROFI_MENU" | rofi -dmenu \
  -theme "$IMAGE_PICKER_CONFIG" \
  -markup-rows \
  -hover-select \
  -me-select-entry '' \
  -me-accept-entry 'MousePrimary')

[[ -z "$SELECTED_WALLPAPER" ]] && exit 0

SELECTED_WALLPAPER_NAME=$(echo "$SELECTED_WALLPAPER" | sed 's/ (current)//')

if [[ -n "$SELECTED_WALLPAPER_NAME" ]]; then
  "$HOME/scripts/DarkLight.sh" "$SELECTED_WALLPAPER_NAME"
fi
