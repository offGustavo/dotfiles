#!/usr/bin/env bash


chosen=$(echo -e "Ativar Externo Esquerda\nAtivar Externo Acima\nDesativar Externo\nAtivar Interno\nDesativar Interno\nEspelhar" | fuzzel -d -p "Monitors:")

case "$chosen" in
"Ativar Externo Esquerda")
  cosmic-randr position eDP-1 1920 0
  cosmic-randr mode HDMI-A-2 1920 1080
  cosmic-randr position HDMI-A-2 0 0
  ;;
"Ativar Externo Acima")
  cosmic-randr position eDP-1 0 1080
  cosmic-randr mode HDMI-A-2 1920 1080
  cosmic-randr position HDMI-A-2 0 0
  ;;
"Desativar Externo")
  cosmic-randr disable HDMI-A-2
  ;;
"Desativar Interno")
  cosmic-randr disable eDP-1
  ;;
"Ativar Interno")
  cosmic-randr enable eDP-1
  ;;
"Espelhar")
  cosmic-randr mirror HDMI-A-2 eDP-1
  ;;
*)
  echo "Opção inválida"
  ;;
esac
