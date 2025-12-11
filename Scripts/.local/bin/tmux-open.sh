#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Uso: $0 [--float] <nome_do_programa> [args...]"
  exit 1
fi

if [ "$1" == "--float" ]; then
  FLOAT_MODE=true
  shift
else
  FLOAT_MODE=false
fi

PROGRAM="$1"
shift
ARGS=("$@")

CWD=$(tmux display-message -p -F "#{pane_current_path}")

if [ "$FLOAT_MODE" = true ]; then
  tmux popup \
    -E \
    -w 90% -h 80% \
    -T "$PROGRAM" \
    -d "$CWD" \
    "$PROGRAM" "${ARGS[@]}"
else
  if tmux list-windows -F "#{window_name}" | grep -q "^$PROGRAM$"; then
    tmux select-window -t "$PROGRAM"
    exit 0
  fi
  tmux new-window -n "$PROGRAM" -c "#{pane_current_path}" "$PROGRAM" "${ARGS[@]}"
fi
