#!/bin/bash

echo "Setting Super+{1..9} To move to Workspace"
for i in {1..9}; do gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-$i" "['<Super>$i']"; done

echo "Setting Super+0 To move to Workspace"
gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-10" "['<Super>0']"

echo "Setting Super+Shift+{1..9} To move window to Workspace"
for i in {1..9}; do gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-$i" "['<Super><Shift>$i']"; done

echo "Setting Super+Shift+0 To move window to Workspace"
gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-10" "['<Super><Shift>0']"

echo "Setting Super+Alt+{1..9} To switch to Application"
for i in {1..9}; do gsettings set "org.gnome.shell.keybindings" "switch-to-application-$i" "['<Super><Alt>$i']"; done

printf "Finish Config Processs\n\tEnjoy your gnome"
