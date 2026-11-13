#!/usr/bin/env bash

# set -xe

current_scheme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
  ln -sf ~/.config/waybar/light.css ~/.config/waybar/colors.css
else
  ln -sf ~/.config/waybar/dark.css ~/.config/waybar/colors.css
fi

WAYBAR_PID=$(pgrep waybar)
if [[ -n "$WAYBAR_PID"  ]]; then
  kill "$WAYBAR_PID"
  if [[ "$1" == "--restart" ]]; then
    sleep 1
    waybar &
  fi
else
  waybar &
fi
