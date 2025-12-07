#!/bin/bash
current_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)

kill_if_running() {
  pgrep -x "$1" >/dev/null && killall "$1"
}

start_sway() {
  local wallpaper_name="$1"
  if [[ -n "$wallpaper_name" ]]; then
    ~/.config/hypr/scripts/start_swaybg.lua -n "$wallpaper_name"
  else
    ~/.config/hypr/scripts/start_swaybg.lua
  fi
}

start_waybar() {
  kill_if_running waybar
  if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
    ln -sf ~/.config/hypr/waybar/dark.css ~/.config/hypr/waybar/colors.css
  else
    ln -sf ~/.config/hypr/waybar/light.css ~/.config/hypr/waybar/colors.css
  fi
  waybar -c ~/.config/hypr/waybar/config.jsonc -s ~/.config/hypr/waybar/style.css
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
