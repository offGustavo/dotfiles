#!/bin/bash

chosen=$(echo -e "Ativar Externo Esquerda\nAtivar Externo Acima\nDesativar Externo\nAtivar Interno\nDesativar Interno\nEspelhar" | wofi -d)

case "$chosen" in
"Ativar Externo Esquerda")
  gdctl set --logical-monitor --monitor eDP-1 --logical-monitor --primary --monitor HDMI-1 --left-of eDP-1
  ;;
"Ativar Externo Acima")
  gdctl set --logical-monitor --monitor eDP-1 --logical-monitor --primary --monitor HDMI-1 --above eDP-1
  ;;
"Desativar Externo")
  gdctl set --logical-monitor --primary --monitor eDP-1
  ;;
"Desativar Interno")
  gdctl set --logical-monitor --primary --monitor HDMI-1
  ;;
"Ativar Interno")
  gdctl set --logical-monitor --primary --monitor eDP-1
  ;;
"Espelhar")
  gdctl set --logical-monitor --primary --monitor HDMI-1 --monitor eDP-1
  ;;
*)
  echo "Opção inválida"
  ;;
esac
