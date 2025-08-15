#!/bin/bash

# Obtém a lista de dispositivos de saída de áudio
sinks=$(pactl list sinks | awk ' /^\s*Name:/ { name = substr($0, index($0, $2)) } /^\s*Description:/ { desc = substr($0, index($0, $2)); print desc " [" name "]"; } ')

# Usa o fuzzel no modo dmenu para selecionar a saída de som
selected_sink=$(echo "$sinks" | rofi -dmenu -p "Sound Output:" | awk -F'[][]' '{ print $2 }')

# Se um dispositivo foi selecionado, define como saída padrão
if [ -n "$selected_sink" ]; then
  pactl set-default-sink "$selected_sink"
  # notify-send "Saída de áudio alterada para: $selected_sink"
else
  notify-send "Nenhuma saída de áudio selecionada"
fi
