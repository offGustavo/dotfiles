for i in {1..9}; do gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-$i" "['<Super>$i']"; done

for i in {1..9}; do gsettings set "org.gnome.shell.keybindings" "switch-to-application-$i" "['<Super><Alt>$i']"; done
gsettings set "org.gnome.shell.keybindings" "switch-to-application-10" "['<Super><Alt>0']"
