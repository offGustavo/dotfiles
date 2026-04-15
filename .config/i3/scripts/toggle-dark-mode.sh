#!/usr/bin/env bash
current_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)
I3_CONFIG=~/.config/i3/config

if [ "$current_scheme" = "'prefer-light'" ] || [ "$current_scheme" = "'default'" ]; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  ln -sf ~/.config/rofi/shared/theme/dark.rasi ~/.config/rofi/shared/colors.rasi
  
  # Remove existing theme block if present
  sed -i '/^# Tokyo Night/,/^$/d' "$I3_CONFIG"
  # Add dark theme
  cat >> "$I3_CONFIG" << 'EOF'
# Tokyo Night Theme
set $fg #c0caf5
set $bg #1a1b26
set $bg_alt #292e39
set $blue #7aa2f7
set $red #f7768e
set $green #98c379
set $purple #c678dd
EOF
else
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  ln -sf ~/.config/rofi/shared/theme/light.rasi ~/.config/rofi/shared/colors.rasi
  
  # Remove existing theme block if present
  sed -i '/^# Tokyo Night/,/^$/d' "$I3_CONFIG"
  # Add light theme
  cat >> "$I3_CONFIG" << 'EOF'
# Tokyo Night Day Theme
set $fg #3760bf
set $bg #e1e2e7
set $bg_alt #c4c8da
set $blue #2e7de9
set $red #f52a65
set $green #587539
set $purple #7847bd
EOF
fi

# Reload i3 to apply changes
i3-msg reload
