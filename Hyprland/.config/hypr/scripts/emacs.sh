#!/usr/bin/env bash

# 1. Try to focus existing Emacs window in Hyprland
if hyprctl clients | grep -q "class: Emacs"; then
    hyprctl dispatch focuswindow class:Emacs
    exit 0
fi

# 2. Check if server is running, if not start daemon
if ! emacsclient --eval "(emacs-pid)" 2>/dev/null; then
    # Start emacs daemon in the background
    emacs --daemon &
    # Wait for daemon to be ready
    sleep 1
fi

# 3. Connect to server
emacsclient -c -n "$@"
