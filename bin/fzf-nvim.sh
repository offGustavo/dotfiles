#!/usr/bin/env bash

mapfile -t FILES < <(fzf --multi)

# Exit if nothing was selected (Esc / Ctrl-C / no match)
[[ ${#FILES[@]} -eq 0 ]] && exit 0

nvim -- "${FILES[@]}"
