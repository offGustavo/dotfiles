#!/usr/bin/env bash

DMS_PID=$(pgrep dms)
if [[ -n "$DMS_PID" ]]; then
    dms ipc call night toggle
    exit 0
fi

PID=$(pgrep wlsunset)
if [[ -n "$PID" ]]; then
  kill $PID
  exit 0
fi

wlsunset -t 3000 &
exit 0
