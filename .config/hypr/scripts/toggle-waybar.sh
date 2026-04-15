#/usr/bin/env bash 

WAYBAR_PID=$(pgrep waybar)
if [[ -n "$WAYBAR_PID"  ]]; then
  kill "$WAYBAR_PID" &
  if [[ "$1" == "--restart" ]]; then
    sleep 1
    waybar &
  fi 
  exit 0
fi

waybar &
exit 0
