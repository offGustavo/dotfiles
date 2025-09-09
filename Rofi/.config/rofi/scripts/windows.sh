#!/bin/bash

case "$1" in
  --alt-tab)
    rofi -show window -kb-accept-entry '!Alt-Tab' -kb-row-down Alt-Tab
    ;;
  *)
    rofi -show window
    ;;
esac
