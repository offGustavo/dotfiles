#!/bin/bash
current_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    notify-send "Dark Mode" "Switched to dark mode"
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    notify-send "Light Mode" "Switched to light mode"
fi
