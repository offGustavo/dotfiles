#!/usr/bin/env bash

# Check if screenkey is running
PID=$(pgrep screenkey)
if [[ -n "$PID" ]]; then
    # Kill all screenkey processes
    kill "$PID"
else
    # Start screenkey detached from terminal
    nohup screenkey --geometry 200x400+1700+0 -s medium --opacity 0.4 > /dev/null 2>&1 &
fi
