#!/usr/bin/env bash

chosen=$(echo -e "Ativar Externo Direita\nAtivar Externo Acima\nDesativar Externo\nAtivar Interno\nDesativar Interno\nEspelhar" | fuzzel -d -p "Escolha uma opção:")

case "$chosen" in
"Ativar Externo Direita")
  niri msg output HDMI-A-2 on
  niri msg output HDMI-A-2 position set 1920 0
  ;;
"Ativar Externo Acima")
  niri msg output HDMI-A-2 position set 0 -- -1080
  ;;
"Desativar Externo")
  niri msg output HDMI-A-2 off
  ;;
"Desativar Interno")
  niri msg output eDP-1 off
  ;;
"Ativar Interno")
  niri msg output eDP-1 on
  ;;
"Espelhar")
  notify-send "TODO:" "No support for now"
  ;;
*)
  echo "Opção inválida"
  ;;
esac
