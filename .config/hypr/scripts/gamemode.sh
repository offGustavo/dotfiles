#!/usr/bin/env sh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ]; then
  hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword animation borderangle,0; \
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
	    keyword decoration:fullscreen_opacity 1;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
  # hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
  notify-send "Gamemode[ON]" "Power Profile: Performance"

  powerprofilesctl performance
  exit 0
else
  notify-send "Gamemode[OFF]" "Power Profile: Power-Saver"
  # hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
  hyprctl reload
  powerprofilesctl power-saver
  exit 0
fi
