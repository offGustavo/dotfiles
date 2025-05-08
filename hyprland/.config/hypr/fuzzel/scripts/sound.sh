#!/bin/bash

sinks=$(pactl list sinks | awk ' /^\s*Name:/ { name = substr($0, index($0, $2)) } /^\s*Description:/ { desc = substr($0, index($0, $2)); print desc " [" name "]"; } ')

selected_sink=$(echo "$sinks" | fuzzel -d | awk -F'[][]' '{ print $2 }')

if [ -n "$selected_sink" ]; then
  pactl set-default-sink "$selected_sink"
  # notify-send "Saída de áudio alterada para: $selected_sink"
  exit 0
fi

notify-send "Nenhuma saída de áudio selecionada"
