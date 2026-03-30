#!/usr/bin/env bash

PID=$(pgrep wlsunset)
if [[ -n "$PID" ]]; then
  kill $PID
  exit 0
fi

wlsunset -t 3000 &
