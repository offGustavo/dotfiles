#!/bin/env bash

if pgrep -x hyprsunset >/dev/null; then
  killall hyprsunset
  exit 0
fi

hyprsunset -g 100% -t 3500 &
