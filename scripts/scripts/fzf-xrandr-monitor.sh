#!/bin/bash

chosen=$(echo -e "Ativar Externo Esquerda\nAtivar Externo Acima\nDesativar Externo\nAtivar Interno\nDesativar Interno\nEspelhar" | fzf --no-preview)

case "$chosen" in
"Ativar Externo Esquerda")
  xrandr --output HDMI-1-0 --mode 1920x1080 --preferred --left-of eDP-1
  ;;
"Ativar Externo Acima")
  xrandr --output HDMI-1-0 --mode 1920x1080 --preferred --above eDP-1
  ;;
"Desativar Externo")
  xrandr --output HDMI-1-0 --off --output eDP-1 --mode 1920x1080 --preferred
  ;;
"Desativar Interno")
  xrandr --output eDP-1 --off
  ;;
"Ativar Interno")
  xrandr --output eDP-1 --mode 1920x1080 --right-of HDMI-1-0
  ;;
"Espelhar")
  xrandr --output HDMI-1-0 --same-as eDP-1
  ;;
*)
  echo "Opção inválida"
  ;;
esac
