#!/usr/bin/env bash

CONFIG="$HOME/.config/niri/waybar/config.jsonc"
CSS="$HOME/.config/niri/waybar/style.css"

# Kill all running Waybar processes
if pgrep -x waybar > /dev/null; then
    echo "Killing existing Waybar instances..."
    pkill -x waybar
    # Wait until all are terminated
    while pgrep -x waybar > /dev/null; do
        sleep 0.2
    done
fi

# Relaunch Waybar
echo "Starting Waybar..."

nohup waybar -c "$CONFIG" -s "$CSS" >/dev/null 2>&1 &

echo "Waybar relaunched successfully."
