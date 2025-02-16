#!/bin/bash

chosen=$(echo -e "Ativar Externo Esquerda\nAtivar Externo Acima\nDesativar Externo\nAtivar Interno\nDesativar Interno\nEspelhar" | fuzzel -d -p "Monitors:")

case "$chosen" in
"Ativar Externo Esquerda")
  xrandr --output HDMI-1-0 --mode 1920x1080 --preferred --left-of eDP-1
  ;;
"Ativar Externo Acima")
  xrandr --output HDMI-1-0 --mode 1920x1080 --preferred --above eDP-1
  ;;
"Desativar Externo")
  xrandr --output HDMI-1-0 --off
  ;;
"Desativar Interno")
  cosmic-randr disable eDP-1
  ;;
"Ativar Interno")
  cosmic-randr enable eDP-1
  ;;
"Espelhar")
  xrandr --output HDMI-1-0 --same-as eDP-1
  ;;
*)
  echo "Opção inválida"
  ;;
esac
sac
