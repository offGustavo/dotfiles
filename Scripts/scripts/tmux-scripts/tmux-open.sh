#!/bin/bash

if [ -z "$1" ]; then
  echo "Uso: $0 <nome_do_programa>"
  exit 1
fi

if tmux list-windows -F "#{window_name}" | grep -q "$1"; then
  tmux select-window -t "$1"
  exit 0
fi

tmux new-window -n "$1" -c "#{pane_current_path}" "$1"
