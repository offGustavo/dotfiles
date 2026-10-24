#!/usr/bin/env bash

systemctl --user start gnome-keyring-daemon.service & disown
# cosmic-ext-alternative-startup & disown
# dms run & disown
killall mako & mako & disown
killall waybar & waybar & disown
killall wayscriber & wayscriber -d & disown
# sleep 1 && swaybg -i ~/Pictures/Wallpapers/The-Path-of-Giants.png & disown
sleep 1 && killall swaybg & swaybg -i ~/Downloads/pine-watt-2Hzmz15wGik-unsplash.jpg & disown
