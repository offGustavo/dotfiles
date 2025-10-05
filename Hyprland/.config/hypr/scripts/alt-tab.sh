#!/bin/bash
# Simple Alt+Tab logic for Hyprland (sorted by focus history)

STATE_FILE="/tmp/hypr-alt-tab.state"

# Get all windows sorted by focus history (oldest first)
mapfile -t windows < <(hyprctl clients -j | jq -r 'sort_by(.focusHistoryID) | .[].address')

# Exit if there are no windows
[[ ${#windows[@]} -eq 0 ]] && exit 0

# Read current index (if exists)
current_index=0
if [[ -f $STATE_FILE ]]; then
    current_index=$(<"$STATE_FILE")
fi

# Calculate next index, wrapping around
next_index=$(( (current_index + 1) % ${#windows[@]} ))

# Save new index
echo "$next_index" > "$STATE_FILE"

# Focus next window
hyprctl dispatch focuswindow "address:${windows[$next_index]}"

