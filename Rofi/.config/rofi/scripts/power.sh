#!/bin/bash
chosen=$(echo -e "Poweroff\nReboot\nSuspend\nLog out\nPower Profile" | rofi -d -p "Power Management:")
case "$chosen" in
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
  chosen2=$(echo -e "Power Saver\nBalanced\nPerformance" | rofi -d -p "Power Profile ($(powerprofilesctl get)):")
  case "$chosen2" in
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
