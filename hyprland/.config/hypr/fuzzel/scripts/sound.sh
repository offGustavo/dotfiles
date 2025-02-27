#!/bin/bash

# Obtém a lista de dispositivos de saída de áudio
sinks=$(pactl list short sinks | awk '{print $1" "$2}')

# Usa o fuzzel --config $HOME/.config/hypr/fuzzel/fuzzel.ini  no modo dmenu para selecionar a saída de som
selected_sink=$(echo "$sinks" | fuzzel --config $HOME/.config/hypr/fuzzel/fuzzel.ini --dmenu | awk '{print $2}')

# Se um dispositivo foi selecionado, define como saída padrão
if [ -n "$selected_sink" ]; then
  pactl set-default-sink "$selected_sink"
  notify-send "Saída de áudio alterada para: $selected_sink"
else
  notify-send "Nenhuma saída de áudio selecionada"
fi
