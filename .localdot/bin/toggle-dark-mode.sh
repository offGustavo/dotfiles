#!/usr/bin/env bash

# set -xe

current_scheme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'
else
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-light"'
fi

if  command -v dms &> /dev/null ; then
  dms ipc theme toggle
fi 

# if command -v waybar &> /dev/null ; then
#   ~/.config/waybar/scripts/toggle-waybar.sh --restart
# fi 

if command -v swaybg &> /dev/null ; then
  PID=$(pgrep swaybg)
  if [[ -n "$PID" ]]; then
    kill "$PID"
  fi
  if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
    swaybg -i /home/gustavo/Pictures/Wallpapers/The-Path-of-Giants.png
  else
    swaybg -i /home/gustavo/Pictures/Wallpapers/bliss.jpg
  fi
fi 

if command -v rofi &> /dev/null ; then
  /home/gustavo/.config/rofi/scripts/toggle-rofi-theme.sh
fi
