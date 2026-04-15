#!/usr/bin/env bash

### --- SELECT PATH USING ZOXIDE + FUZZEL --- ###

if [[ $# -eq 1 ]]; then
  selected=$(zoxide query "$1")
else
  selected=$(zoxide query -l -s | fuzzel --dmenu --prompt="Project: ")
  selected=$(echo "$selected" | awk '{print $2}')
fi

if [[ -z "$selected" ]]; then
  echo "No path selected!"
  exit 0
fi

selected_name=$(basename "$selected")


### --- CHECK IF A ZED WINDOW ALREADY EXISTS FOR THIS PATH --- ###

# List Hyprland windows: address | class | title
clients=$(hyprctl clients -j | jq -r '.[] | "\(.address) | \(.class) | \(.title)"')

# Search for Zed window that contains the selected path in title
existing=$(echo "$clients" | grep "Zed" | grep "$selected")

if [[ -n "$existing" ]]; then
  # Extract window address
  win_addr=$(echo "$existing" | awk -F'|' '{print $1}' | xargs)

  echo "Zed window already exists. Focusing $win_addr"
  hyprctl dispatch focuswindow "address:$win_addr"
  exit 0
fi


### --- IF NOT FOUND, CREATE A NEW ZED WINDOW --- ###

echo "Opening new Zed window for: $selected"
zeditor -n "$selected" &>/dev/null & disown

sleep 1

### --- FOCUS THE NEW WINDOW AUTOMATICALLY --- ###
clients=$(hyprctl clients -j | jq -r '.[] | "\(.address) | \(.class) | \(.title)"')
new_win=$(echo "$clients" | grep "Zed" | grep "$selected")
if [[ -n "$new_win" ]]; then
  win_addr=$(echo "$new_win" | awk -F'|' '{print $1}' | xargs)
  hyprctl dispatch focuswindow "address:$win_addr"
fi
