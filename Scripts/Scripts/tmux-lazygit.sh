#!/bin/bash

if tmux list-windows -F "#{window_name}" | grep -q "lazygit"; then
  tmux select-window -t lazygit
else
  tmux new-window -n lazygit -c "#{pane_current_path}" lazygit
fi
