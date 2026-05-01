#!/usr/bin/env bash

# set -xe

current_scheme=$(dconf read /org/gnome/desktop/interface/color-scheme)

THEME=""

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'
  THEME="dark"
else
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-light"'
  THEME="light"
fi

PID_dms=$(pgrep dms)
if [[ -n "$PID_dms" ]]; then
  dms ipc theme toggle
fi 

# FIXME: fix this shit code
if command -v swaybg &> /dev/null ; then
  PID=$(pgrep swaybg)
  if [[ -n "$PID" ]]; then
    kill "$PID"
    if [ "$THEME" = "light" ]; then
      swaybg -i /home/gustavo/Pictures/Wallpapers/bliss.jpg
    else
      swaybg -i /home/gustavo/Pictures/Wallpapers/The-Path-of-Giants.png
    fi
  fi
fi 

if command -v rofi &> /dev/null ; then
  $HOME/.config/rofi/scripts/toggle-rofi-theme.sh $THEME
fi

if command -v fuzzel &> /dev/null ; then
  $HOME/.config/fuzzel/scripts/toggle-fuzzel-theme.sh $THEME
fi

if command -v i3 &> /dev/null ; then
  $HOME/.config/i3/scripts/toggle-dark-mode.sh $THEME
fi
