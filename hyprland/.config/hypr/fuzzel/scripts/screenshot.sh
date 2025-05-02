#!/bin/bash

CHOOSE=$(echo -e "Selecionar(Clipboard)\nSelecionar(Salvar)\nMonitor(Clipboard)\nMonitor(Salvar)" | fuzzel -d)

case "$CHOOSE" in
"Selecionar(Clipboard)")
  hyprshot -m region --clipboard-only
  ;;
"Selecionar(Salvar)")
  hyprshot -m region -o ~/Pictures/Screenshots/Hyprshot
  ;;
"Monitor(Clipboard)")
  hyprshot -m monitor --clipboard-only
  ;;
"Monitor(Salvar)")
  hyprshot -m monitor -o ~/Pictures/Screenshots/Hyprshot
  ;;
esac
