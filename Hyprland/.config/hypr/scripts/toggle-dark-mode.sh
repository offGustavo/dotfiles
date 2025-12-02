#!/bin/bash
current_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)

kill_if_running() {
    pgrep -x "$1" >/dev/null && killall "$1"
}

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    kill_if_running waybar
    ln -sf ~/.config/hypr/waybar/dark.css ~/.config/hypr/waybar/colors.css
    waybar -c ~/.config/hypr/waybar/config.jsonc -s ~/.config/hypr/waybar/style.css
    kill_if_running swaybg
    swaybg -i /home/gustavo/Pictures/Wallpapers/dharmx-Walls/mountain/a_rocky_cliff_with_trees_and_fog.jpg -m fill
    ln -sf ~/.config/fuzzel/dark.ini ~/.config/fuzzel/colors.ini
    # notify-send "Dark Mode" "Switched to dark mode"
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    kill_if_running waybar
    ln -sf ~/.config/hypr/waybar/light.css ~/.config/hypr/waybar/colors.css
    waybar -c ~/.config/hypr/waybar/config.jsonc -s ~/.config/hypr/waybar/style.css
    kill_if_running swaybg
    swaybg -i /home/gustavo/Pictures/Wallpapers/dharmx-Walls/anime/a_cartoon_of_a_girl_standing_under_a_tree_with_purple_flowers.png -m fill
    ln -sf ~/.config/fuzzel/light.ini ~/.config/fuzzel/colors.ini
    # notify-send "Light Mode" "Switched to light mode"
fi
