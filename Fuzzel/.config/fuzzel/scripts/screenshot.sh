#!/usr/bin/env bash


CHOOSE=$(echo -e "Selecionar(Clipboard) Super+Shift+s\nSelecionar(Salvar) Super+Shift+Control+s\nMonitor(Clipboard) Super+Alt+s\nMonitor(Salvar) Super+Control+s" | fuzzel -d)

case "$CHOOSE" in
"Selecionar(Clipboard) Super+Shift+s")
  hyprshot -m region --clipboard-only
  ;;
"Selecionar(Salvar) Super+Shift+Control+s")
  hyprshot -m region -o ~/Pictures/Screenshots/Hyprshot
  ;;
"Monitor(Clipboard) Super+Alt+s")
  hyprshot -m output --clipboard-only
  ;;
"Monitor(Salvar) Super+Control+s")
  hyprshot -m output -o ~/Pictures/Screenshots/Hyprshot
  ;;
esac
