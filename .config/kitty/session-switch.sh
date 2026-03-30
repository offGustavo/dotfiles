#!/usr/bin/env bash

# Get the list of sessions
sessions=$(kitty @ ls | jq -r '.[] | .id + " " + .name')

# Use fzf to select a session
selected_session=$(echo "$sessions" | fzf --height 40% --reverse)

# Extract the session ID
session_id=$(echo "$selected_session" | awk '{print $1}')

# Switch to the selected session
if [ -n "$session_id" ]; then
    kitty @ goto-session "$session_id"
fi

