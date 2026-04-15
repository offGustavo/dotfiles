#!/usr/bin/env bash
#
#
waybar_mode=false

# Parse command line arguments
for arg in "$@"; do
  case $arg in
    --waybar)
      waybar_mode=true
      shift
      ;;
  esac
done

# Set fuzzel command based on waybar mode
if [ "$waybar_mode" = true ]; then
  fuzzel_command="fuzzel -a top-right -w 20 -l 10 -d --x-margin 120 -p "
else
  fuzzel_command="fuzzel -d -p "
fi

# Obtém a lista de dispositivos de saída de áudio
sinks=$(pactl list sinks | awk ' /^\s*Name:/ { name = substr($0, index($0, $2)) } /^\s*Description:/ { desc = substr($0, index($0, $2)); print desc " [" name "]"; } ')

# Usa o fuzzel no modo dmenu para selecionar a saída de som
selected_option=$(echo -e "$sinks\nExit" | eval $fuzzel_command'"Select Audio Output:"')

# Processa a seleção
if [ -z "$selected_option" ]; then
  exit 0
fi

# Extrai o nome do sink da opção selecionada
selected_sink=$(echo "$selected_option" | awk -F'[][]' '{ print $2 }')

# Verifica se foi selecionado "Exit"
if [ "$selected_option" = "Exit" ]; then
  exit 0
fi

# Se um dispositivo foi selecionado, define como saída padrão
if [ -n "$selected_sink" ]; then
  pactl set-default-sink "$selected_sink"
  # notify-send "Saída de áudio alterada para: $selected_sink"
else
  notify-send "Nenhuma saída de áudio selecionada"
fi
