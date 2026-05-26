#!/usr/bin/env bash

# Parse sinks from wpctl status
# Format: "   45. Built-in Audio Analog Stereo        [vol: 0.70]"
# Active sink has "*" before the ID

sink_lines=$(wpctl status | awk '
  /Sinks:/ { in_sinks=1; next }
  in_sinks && /^\s*│\s*$/ { in_sinks=0 }
  in_sinks && /^\s*[│├└]/ && /[0-9]+\./ {
    line = $0
    # Check if this is the active sink (has *)
    active = (line ~ /\*/) ? 1 : 0
    # Extract ID and name+vol
    match(line, /[0-9]+\..*/)
    entry = substr(line, RSTART, RLENGTH)
    # Trim trailing whitespace
    gsub(/[[:space:]]+$/, "", entry)
    if (active)
      print "* " entry
    else
      print "  " entry
  }
')

if [ -z "$sink_lines" ]; then
  notify-send "audio-switch" "No audio sinks found"
  exit 1
fi

# Show rofi menu — active sink appears with * prefix
selected=$(echo "$sink_lines" | fuzzel --dmenu)

[ -z "$selected" ] && exit 0

# Extract the numeric sink ID from the selected line
sink_id=$(echo "$selected" | grep -oP '(?<=\*?\s{0,3})\d+(?=\.)')

if [ -z "$sink_id" ]; then
  notify-send "audio-switch" "Could not parse sink ID"
  exit 1
fi

wpctl set-default "$sink_id"

# Get friendly name for notification (everything between ID. and [vol)
sink_name=$(echo "$selected" | sed 's/^[* ]*//' | grep -oP '\d+\.\s*\K[^\[]+' | sed 's/[[:space:]]*$//')

notify-send "🔊 Audio Output" "Switched to: ${sink_name}"
