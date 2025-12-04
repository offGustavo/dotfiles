#!/bin/bash
# Simplified and linear Alt+Tab logic for Hyprland

STATE_DIR="/tmp/hypr-alt-tab"
STATE_FILE="$STATE_DIR/state"
TIME_FILE="$STATE_DIR/last_press"
CURRENT_INDEX_FILE="$STATE_DIR/current_index"

# Cooldown in seconds (time within which presses count as "continuous")
COOLDOWN=0.8

# Create state directory if it doesn't exist
mkdir -p "$STATE_DIR"

# Function to get all windows sorted by focus history (most recent first)
get_windows_by_focus() {
    hyprctl clients -j | jq -r 'sort_by(-.focusHistoryID) | .[].address'
}

# Function to get currently focused window
get_focused_window() {
    hyprctl activewindow -j | jq -r '.address'
}

# Function to check if window exists
window_exists() {
    local window="$1"
    [[ -n "$window" ]] && hyprctl clients -j | jq -r '.[].address' | grep -q "^${window}$"
}

# Get current windows and focused window
mapfile -t windows < <(get_windows_by_focus)
current_focused=$(get_focused_window)

# Exit if no windows or only one window
[[ ${#windows[@]} -le 1 ]] && exit 0

# Determine direction
direction="forward"
[[ "$1" == "--reverse" ]] && direction="reverse"

# Get current time
current_time=$(date +%s.%N)

# Read last press time
last_press=0
[[ -f "$TIME_FILE" ]] && last_press=$(<"$TIME_FILE")

# Calculate time difference
time_diff=$(echo "$current_time - $last_press" | bc -l 2>/dev/null || echo "1")

# Check if we're continuing the Alt+Tab session
continuing_session=false
if (( $(echo "$time_diff <= $COOLDOWN" | bc -l 2>/dev/null || echo "0") )); then
    continuing_session=true
fi

# Find current window index in the list
current_index=-1
for i in "${!windows[@]}"; do
    if [[ "${windows[$i]}" == "$current_focused" ]]; then
        current_index=$i
        break
    fi
done

# Calculate target index
if [[ "$continuing_session" == "true" ]] && [[ -f "$CURRENT_INDEX_FILE" ]]; then
    # Continue from last saved index
    saved_index=$(<"$CURRENT_INDEX_FILE")
    if [[ "$direction" == "reverse" ]]; then
        target_index=$(( (saved_index - 1 + ${#windows[@]}) % ${#windows[@]} ))
    else
        target_index=$(( (saved_index + 1) % ${#windows[@]} ))
    fi
else
    # Start new session - move from current window
    if [[ $current_index -eq -1 ]]; then
        # Current window not in list, start from beginning
        target_index=0
    else
        # Move from current window
        if [[ "$direction" == "reverse" ]]; then
            target_index=$(( (current_index - 1 + ${#windows[@]}) % ${#windows[@]} ))
        else
            target_index=$(( (current_index + 1) % ${#windows[@]} ))
        fi
    fi
fi

# Ensure target index is valid and window exists
attempts=0
max_attempts=${#windows[@]}
while [[ $attempts -lt $max_attempts ]] && ! window_exists "${windows[$target_index]}"; do
    if [[ "$direction" == "reverse" ]]; then
        target_index=$(( (target_index - 1 + ${#windows[@]}) % ${#windows[@]} ))
    else
        target_index=$(( (target_index + 1) % ${#windows[@]} ))
    fi
    ((attempts++))
done

# Exit if no valid window found
[[ $attempts -eq $max_attempts ]] && exit 1

# Save state
echo "$current_time" > "$TIME_FILE"
echo "$target_index" > "$CURRENT_INDEX_FILE"

# Focus the target window
target_window="${windows[$target_index]}"
if window_exists "$target_window"; then
    hyprctl dispatch focuswindow "address:$target_window"
    hyprctl dispatch bringactivetotop
fi

# Visual feedback: dim inactive windows temporarily
hyprctl keyword decoration:dim_inactive true

# Clear any existing reset timer
[[ -f "$STATE_DIR/dim_timer" ]] && kill "$(<"$STATE_DIR/dim_timer")" 2>/dev/null

# Start timer to reset dimming
(
    sleep 1.2
    hyprctl keyword decoration:dim_inactive false 2>/dev/null
) &
echo $! > "$STATE_DIR/dim_timer"
