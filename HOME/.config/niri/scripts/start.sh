#!/usr/bin/env bash

set -x

systemctl --user start gnome-keyring-daemon.service & disown

# cosmic-ext-alternative-startup & disown

killall mako 
# mako & disown
swaync & disown
killall waybar 
waybar & disown

# dms run & disown


killall wayscriber 
wayscriber -d & disown

# sleep 1 && swaybg -i ~/Pictures/Wallpapers/The-Path-of-Giants.png & disown
# sleep 1 && killall swaybg & swaybg -i ~/Downloads/pexels-david-jusko-2674423-6245540.jpg & disown

$(which start-swaybg.lua)

# $HOME/.local/bin/start-swaybg.lua

