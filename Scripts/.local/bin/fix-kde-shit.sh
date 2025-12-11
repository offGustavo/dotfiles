#!/bin/env bash

gsettings reset org.gnome.desktop.interface icon-theme

gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

systemctl --user start gnome-keyring-daemon.service
