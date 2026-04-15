#!/usr/bin/env bash

# Check if screenkey is running
if pgrep -x "screenkey" > /dev/null; then
    # Kill all screenkey processes
    pkill -x screenkey
else
    # Start screenkey detached from terminal
    nohup /usr/bin/screenkey --geometry 200x400+1700+0 -s medium --opacity 0.4 > /dev/null 2>&1 &
fi
