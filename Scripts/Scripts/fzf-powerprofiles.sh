#!/bin/bash

$CHOICE=$(echo -e "Power Saver\nBalenced\nPerformance" | fzf --no-multi --no-preview --header "Current Mode: $(powerprofilesctl get)")

case "$CHOICE" in
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
