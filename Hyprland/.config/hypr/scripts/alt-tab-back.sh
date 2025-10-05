#!/bin/bash
# ~/.config/hypr/scripts/hypr-alt-tab-back.sh

STATE_FILE="/tmp/hypr-alt-tab.state"
mapfile -t windows < <(hyprctl clients -j | jq -r 'sort_by(.focusHistoryID) | .[].address')

[[ ${#windows[@]} -eq 0 ]] && exit 0

current_index=0
if [[ -f $STATE_FILE ]]; then
    current_index=$(<"$STATE_FILE")
fi

prev_index=$(( (current_index - 1 + ${#windows[@]}) % ${#windows[@]} ))
echo "$prev_index" > "$STATE_FILE"
hyprctl dispatch focuswindow "address:${windows[$prev_index]}"
