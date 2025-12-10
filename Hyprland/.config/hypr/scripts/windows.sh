#!/usr/bin/env bash

# hypr-windows.sh
# Lists all windows in Hyprland, shows them in fuzzel, and focuses the selected one.

# Get all clients (windows) with address and title
clients=$(hyprctl clients -j | jq -r '.[] | "\(.address) | \(.workspace.name) | \(.class) - \(.title)"')

# Show in fuzzel and get user selection
selection=$(echo "$clients" | fuzzel --dmenu --prompt="Windows: " | awk -F'|' '{print $1}' | xargs)

# If a window was selected, focus it
if [[ -n "$selection" ]]; then
  hyprctl dispatch focuswindow "address:$selection"
fi
