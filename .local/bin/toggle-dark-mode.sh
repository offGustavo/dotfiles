#!/usr/bin/env bash

set -xe

current_scheme=$(dconf read /org/gnome/desktop/interface/color-scheme)

THEME=""

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'
  THEME="dark"
else
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-light"'
  THEME="light"
fi

if command -v rofi &>/dev/null; then
  if [ "$THEME" = "light" ]; then
    ln -sf ~/.config/rofi/shared/theme/light.rasi ~/.config/rofi/shared/colors.rasi
  else
    ln -sf ~/.config/rofi/shared/theme/dark.rasi ~/.config/rofi/shared/colors.rasi
  fi
fi

if command -v fuzzel &>/dev/null; then
  if [ "$THEME" = "light" ]; then
    ln -sf "$HOME/.config/fuzzel/light.ini" "$HOME/.config/fuzzel/colors.ini"
  else
    ln -sf "$HOME/.config/fuzzel/dark.ini" "$HOME/.config/fuzzel/colors.ini"
  fi
fi

if command -v i3 &>/dev/null; then
  "$HOME"/.config/i3/scripts/toggle-dark-mode.sh "$THEME"
fi

if command -v swaybg &>/dev/null; then
  kill $(pgrep swaybg) 2>/dev/null
  [ "$THEME" = "light" ] &&
    swaybg -i /home/gustavo/Pictures/Wallpapers/bliss.jpg ||
    swaybg -i /home/gustavo/Pictures/Wallpapers/The-Path-of-Giants.png
fi

PID_dms=$(pgrep dms)
if [[ -n "$PID_dms" ]]; then
  dms ipc theme toggle
fi

