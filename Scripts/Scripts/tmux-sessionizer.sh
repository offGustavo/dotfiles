#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(fd --hidden -E .git -E .cache -E .astah -E Documents/ -E .cargo -E .local -E .docker -E .fzf -E Downloads -E Documents -E Pictures --type d --search-path ~/.config/ | fzf)
  # selected=$(fd --hidden -E .git --type d --max-depth=2 --search-path ~/Faculdade/ --search-path ~/dotfiles/ --search-path ~/Projetos/ | fzf)
  # selected=$(find ~/Faculdade/ ~/dotfiles/ ~/Projetos/ ~/ -mindepth 1 -maxdepth 2 -type d | fzf)
  # selected=$(fd --hidden --type d | fzf)
  #
# ⚡ fd --search-path ~/ -E={.git,.fzf,TMP,go,.docker,Pictures,Downloads,Documents,snap,Music,Desktop,StirlingPDF} --type d --max-depth=2                   <<<
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s $selected_name -c $selected
  exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
  tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
