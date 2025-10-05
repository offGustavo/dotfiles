#!/bin/bash
# hypr-windows.sh
# Lists all windows in Hyprland, shows them in fuzzel, and focuses the selected one.

# Get all clients (windows) with address and title
clients=$(hyprctl clients -j | jq -r '.[] | "\(.address) | \(.workspace.name) | \(.class) - \(.title)"')

# Show in fuzzel and get user selection
selection=$(echo "$clients" | fuzzel --dmenu --prompt="Windows: " | awk -F'|' '{print $1}' | xargs)

# If a window was selected, focus it
if [[ -n "$selection" ]]; then
  hyprctl dispatch focuswindow "address:$selection"
fi

# hypr-alt-tab.sh
# Simula Alt+Tab usando Hyprland + fuzzel

STATE_FILE="/tmp/hypr-alt-tab.state"

# Pega a lista de janelas (endereços + título)
mapfile -t windows < <(hyprctl clients -j | jq -r '.[] | "\(.address)|\(.class) - \(.title)"')

# Se não houver janelas, sai
[[ ${#windows[@]} -eq 0 ]] && exit 0

# Lê índice atual (posição na lista)
current_index=0
if [[ -f $STATE_FILE ]]; then
    current_index=$(<"$STATE_FILE")
fi

# Calcula próximo índice
next_index=$(( (current_index + 1) % ${#windows[@]} ))

# Atualiza estado
echo "$next_index" > "$STATE_FILE"

# Mostra a lista no fuzzel, com a próxima já pré-selecionada
# Mostramos as janelas com índice na frente para selecionar facilmente
menu=$(printf "%s\n" "${windows[@]}" | nl -w2 -s' ')
selection=$(echo "$menu" | fuzzel --dmenu --prompt="🪟 Windows > " --placeholder="Alt+Tab → ${windows[$next_index]#*|}" )

# Se o usuário não escolheu nada (cancelou), foca direto na próxima
if [[ -z "$selection" ]]; then
    selected="${windows[$next_index]}"
else
    selected=$(echo "$selection" | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//')
fi

# Extrai o endereço e foca
address="${selected%%|*}"
hyprctl dispatch focuswindow "address:$address"
