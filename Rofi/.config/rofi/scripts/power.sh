#!/bin/bash

CHOICE=$(echo -e "Poweroff\nReboot\nSuspend\nLog out\nPower Profile" | rofi -dmenu -p "Power Management:")
case "$CHOICE" in
"Poweroff")
  systemctl poweroff
  ;;
"Reboot")
  systemctl reboot
  ;;
"Suspend")
  systemctl suspend
  ;;
"Log out")
  hyprctl dispatch exit
  ;;
"Logout")
  hyprctl dispatch exit
  ;;
"Power Profile")
  CHOICE2=$(echo -e "Power Saver\nBalenced\nPerformance" | rofi -dmenu -p "Current Mode: $(powerprofilesctl get)")
  case "$CHOICE2" in
  "Power Saver")
    powerprofilesctl set power-saver
    ;;
  "Balanced")
    powerprofilesctl set balanced
    ;;
  "Performance")
    powerprofilesctl set performance
    ;;
  esac
  ;;
*)
  echo "Opção inválida"
  ;;
esac
