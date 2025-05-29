#!/bin/bash

chosen=$(echo -e "Ativar Externo Esquerda\nAtivar Externo Acima\nDesativar Externo\nAtivar Interno\nDesativar Interno\nEspelhar" | fzf --no-preview)

case "$chosen" in
"Ativar Externo Esquerda")
  hyprctl keyword monitor HDMI-A-1, disable
  hyprctl keyword monitor HDMI-A-1, 1920x1080@179.96Hz, -- -1920x0, 1.0
  hyprctl keyword monitor eDP-1, 1920x1080@60Hz, 0x0, 1.0
  ;;
"Ativar Externo Acima")
  hyprctl keyword monitor HDMI-A-1, disable
  hyprctl keyword monitor HDMI-A-1, 1920x1080@179.96Hz, 0x-1080, 1.0
  hyprctl keyword monitor eDP-1, 1920x1080@60Hz, 0x0, 1.0
  ;;
"Desativar Externo")
  hyprctl keyword monitor HDMI-A-1, disable
  ;;
"Desativar Interno")
  hyprctl keyword monitor eDP-1, disable
  ;;
"Ativar Interno")
  hyprctl keyword monitor eDP-1, disable
  hyprctl keyword monitor eDP-1, 1920x1080@60Hz, 0x0, 1.0
  ;;
"Espelhar")
  hyprctl keyword monitor HDMI-A-1, 1920x1080@60Hz, 0x0, 1.0, mirror, eDP-1
  ;;
*)
  echo "Opção inválida"
  ;;
esac

# OPTIONS=(
#   "Monitor Acima (HDMI-A-1): HDMI-A-1, 1920x1080@179.96Hz, 0x-1080, 1.0"
#   "Monitor a Esquerda (HDMI-A-1): HDMI-A-1, 1920x1080@179.96Hz, -- -1920x0, 1.0"
#   "TV Acima (HDMI-A-1): HDMI-A-1, 3840x2160@60, 0x-1080, 2.0"
#   "TV a Esquerda (HDMI-A-1): HDMI-A-1, 3840x2160@59.94Hz, -1920x0, 2.0"
#   "Ativar eDP-1: eDP-1, 1920x1080@60Hz, 0x0, 1.0"
#   "Desativar InternInternoo eDP-1: eDP-1, disable"
#   "Desativar Externo HDMI-A-1: HDMI-A-1, disable"
#   "Espelhar Monitores: HDMI-A-1, 1920x1080@60Hz, 0x0, 1, mirror, eDP-1"
# )
#
# CHOICE=$(printf '%s\n' "${OPTIONS[@]}" | fuzzel -d --config $HOME/.config/hypr/fuzzel/fuzzel.ini -p "Monitors: ")
#
# if [[ -z "$CHOICE" ]]; then
#   echo "Nenhuma configuração selecionada. Saindo."
#   exit 0
# fi
#
# SELECTED_CONFIG="monitor ${CHOICE#*: }"
#
# echo $SELECTED_CONFIG
# hyprctl keyword $SELECTED_CONFIG
#
