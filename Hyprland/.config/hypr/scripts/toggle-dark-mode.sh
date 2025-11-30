#!/bin/bash
current_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    killall waybar
    waybar -c ~/.config/hypr/waybar/config.jsonc -s ~/.config/hypr/waybar/style.css
    ln -sf ~/.config/fuzzel/light.ini ~/.config/fuzzel/fuzzel.ini
    # notify-send "Dark Mode" "Switched to dark mode"
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    killall waybar
    waybar -c ~/.config/hypr/waybar/config.jsonc -s ~/.config/hypr/waybar/light.css
    ln -sf ~/.config/fuzzel/dark.ini ~/.config/fuzzel/fuzzel.ini
    # notify-send "Light Mode" "Switched to light mode"
fi
