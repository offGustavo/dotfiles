#!/usr/bin/env bash

systemctl --user start gnome-keyring-daemon.service & disown
# cosmic-ext-alternative-startup & disown
# dms run & disown
mako & disown
waybar & disown
wayscriber -d & disown
sleep 1 && swaybg -i ~/Pictures/Wallpapers/The-Path-of-Giants.png & disown
