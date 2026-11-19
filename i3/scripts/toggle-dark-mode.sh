#!/usr/bin/env bash

toggle-dark-mode.sh
CURRENT_SCHEME=$(dconf read /org/gnome/desktop/interface/color-scheme)

THEME_FILE=~/.config/i3/config

# BASE
cat << 'EOF' > "$THEME_FILE"

# WARN: AUTOGEN FILE
# Do not edit there, use the included file to edit the config

include ~/.config/i3/src/i3.config

EOF

if [ "$CURRENT_SCHEME" = "'prefer-light'" ]; then

  cat >> "$THEME_FILE" <<'EOF'
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

  cat >> "$THEME_FILE" <<'EOF'
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

i3-msg reload

