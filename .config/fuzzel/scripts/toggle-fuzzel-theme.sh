#!/usr/bin/env bash

if [ "$1" = "light" ]; then
  ln -l -f $HOME/.config/fuzzel/light.ini $HOME/.config/fuzzel/colors.ini
  exit 0
fi

ln -l -f $HOME/.config/fuzzel/dark.ini $HOME/.config/fuzzel/colors.ini
exit 0


