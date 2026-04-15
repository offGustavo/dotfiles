#!/usr/bin/env bash

waybar_mode=false

# Parse command line arguments
for arg in "$@"; do
  case $arg in
    --waybar)
      waybar_mode=true
      shift
      ;;
  esac
done

# Set fuzzel command based on waybar mode
if [ "$waybar_mode" = true ]; then
  fuzzel_command="fuzzel -a top-right -w 20 -l 10 --x-margin 10 -d -p "
else
  fuzzel_command="fuzzel -d -p "
fi

chosen=$(echo -e "Poweroff\nReboot\nSuspend\nLog out\nProfile\nExit" | eval $fuzzel_command'"Power Management:"')

case "$chosen" in
"Exit")
    exit 0
    ;;
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
"Profile")
  chosen2=$(echo -e "Power Saver\nBalanced\nPerformance\nExit" | eval $fuzzel_command'"Current: ($(powerprofilesctl get)):"')
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
"Exit")
    exit 0
    ;;
  esac
  ;;
*)
  echo "Opção inválida"
  ;;
esac
