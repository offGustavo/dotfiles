#!/usr/bin/env bash
current_scheme="$1"

I3_CONFIG=~/.config/i3/config

if [ "$current_scheme" = "light" ]; then

 # Wallpaper
 xwallpaper --zoom ~/Pictures/Wallpapers/dharmx-Walls/cherry/a_tree_with_pink_flowers.jpg


  # Remove existing theme block if present
  sed -i '/^# Tokyo Night/,/^$/d' "$I3_CONFIG"
  # Add light theme
  cat >>"$I3_CONFIG" <<'EOF'
# Tokyo Night Day Theme
set $fg #3760bf
set $bg #e1e2e7
set $bg_alt #c4c8da
set $blue #2e7de9
set $red #f52a65
set $green #587539
set $purple #7847bd
EOF
else

 # Wallpaper
 # xwallpaper --zoom ~/Pictures/Wallpapers/dharmx-Walls/unsorted/a_black_background_with_purple_and_blue_spots.png
 xwallpaper --zoom /home/gustavo/Pictures/Wallpapers/dharmx-Walls/spam/a_street_with_signs_and_lights_01.png
 # xwallpaper --zoom /home/gustavo/Pictures/Wallpapers/dharmx-Walls/centered/a_blue_sky_with_clouds.png

  # Remove existing theme block if present
  sed -i '/^# Tokyo Night/,/^$/d' "$I3_CONFIG"
  # Add dark theme
  cat >>"$I3_CONFIG" <<'EOF'
# Tokyo Night Theme
set $fg #c0caf5
set $bg #1a1b26
set $bg_alt #292e39
set $blue #7aa2f7
set $red #f7768e
set $green #98c379
set $purple #c678dd
EOF
fi

# Reload i3 to apply changes
i3-msg reload
