#!/usr/bin/env bash

# Modificado para extrair as abas/janelas do JSON enviado
sessions=$(kitty @ ls | jq -r '.[] | .tabs[] | .id, .title' | paste -d ' ' - -)

# Use fzf to select a session
selected_session=$(echo "$sessions" | fzf --height 40% --reverse)

# Extract the tab ID
tab_id=$(echo "$selected_session" | awk '{print $1}')

# Switch to the selected tab/session
if [ -n "$tab_id" ]; then
    # O kitty usa focus-tab para alternar dinamicamente entre contextos ativos
    kitty @ focus-tab --match id:"$tab_id"
fi
