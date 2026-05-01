#!/usr/bin/env bash

if [ "$1" = "light" ]; then
  ln -sf ~/.config/rofi/shared/theme/light.rasi ~/.config/rofi/shared/colors.rasi
  exit 0
fi

ln -sf ~/.config/rofi/shared/theme/dark.rasi ~/.config/rofi/shared/colors.rasi
exit 0
