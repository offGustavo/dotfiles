#!/bin/bash

# Verifica se um argumento foi passado
if [ -z "$1" ]; then
  echo "Uso: $0 <nome_do_programa>"
  exit 1
fi

programa="$1"

if tmux list-windows -F "#{window_name}" | grep -q "$programa"; then
  tmux select-window -t "$programa"
else
  tmux new-window -n "$programa" -c "#{pane_current_path}" "$programa"
fi
