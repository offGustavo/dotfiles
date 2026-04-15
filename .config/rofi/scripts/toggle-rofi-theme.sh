#!/usr/bin/env bash

current_scheme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
  ln -sf ~/.config/rofi/shared/theme/light.rasi ~/.config/rofi/shared/colors.rasi
else
  ln -sf ~/.config/rofi/shared/theme/dark.rasi ~/.config/rofi/shared/colors.rasi
fi
