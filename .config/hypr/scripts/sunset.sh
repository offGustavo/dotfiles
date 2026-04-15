#!/usr/bin/env bash

if pgrep -x hyprsunset >/dev/null; then
  PID=$(pgrep hyprsunset)
  kill $PID
  exit 0
fi

hyprsunset -g 100% -t 3500 &
