#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(zoxide query -l -s | fzf --preview "eza --tree --level=1 --git-ignore -A \$(echo {} | awk '{print \$2}')")
fi

selected_path=$(echo "$selected" | awk '{print $2}')

if [[ -z "$selected_path" ]]; then
  exit 0
fi

selected_name=$(basename "$selected_path" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z "$TMUX" ]] && [[ -z "$tmux_running" ]]; then
    tmux new-session -s "$selected_name" -c "$selected_path" -e "NVIM_IN_TMUX=1" "nvim; exec $SHELL"
    exit 0
fi

if [[ -n "$tmux_running" ]]; then
    if ! tmux has-session -t="$selected_name" 2>/dev/null; then
        tmux new-session -ds "$selected_name" -c "$selected_path" -e "NVIM_IN_TMUX=1" "nvim; exec $SHELL"
    fi

    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$selected_name"
    else
        tmux attach-session -t "$selected_name"
    fi
fi
