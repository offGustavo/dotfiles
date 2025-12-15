#!/usr/bin/env bash
current_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)

kill_if_running() {
  pids=$(pgrep "$1")
  if [ -n "$pids" ]; then
    echo "Found PIDs for $1: $pids"
    kill $pids
  else
    echo "No running process named $1"
  fi
}

start_sway() {
  kill_if_running swaybg 
  local wallpaper_name="$1"
  if [[ -n "$wallpaper_name" ]]; then
    ~/.config/hypr/scripts/start_swaybg.lua -n "$wallpaper_name"
  else
    ~/.config/hypr/scripts/start_swaybg.lua
  fi
}

start_waybar() {
  if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
    ln -sf ~/.config/waybar/dark.css ~/.config/waybar/colors.css
  else
    ln -sf ~/.config/waybar/light.css ~/.config/waybar/colors.css
  fi
   ~/.config/hypr/scripts/toggle-waybar.sh --restart
}

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

  ln -sf ~/.config/fuzzel/dark.ini ~/.config/fuzzel/colors.ini
  ln -sf ~/.config/hypr/config/theme/dark.conf ~/.config/hypr/config/theme.conf
  start_waybar
  start_sway

  notify-send "Dark Mode" "Switched to dark mode"
else
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'

  ln -sf ~/.config/fuzzel/light.ini ~/.config/fuzzel/colors.ini
  ln -sf ~/.config/hypr/config/theme/light.conf ~/.config/hypr/config/theme.conf
  start_waybar
  start_sway 

  notify-send "Light Mode" "Switched to light mode"
fi
