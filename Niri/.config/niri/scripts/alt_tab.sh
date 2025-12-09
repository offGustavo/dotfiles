#!/usr/bin/env bash


# Obtém o JSON completo
JSON=$(niri msg --json windows)

# Coleta a janela atual
CURRENT_ID=$(echo "$JSON" | jq '.[] | select(.is_focused == true).id')

# Cria a lista ordenada de janelas usando mapfile (evita SC2207)
mapfile -t WINDOW_IDS < <(
    echo "$JSON" |
        jq -r '.[] | "\(.workspace_id) \(.id)"' |
        sort -n |
        awk '{print $2}'
)

# Se não existir nenhuma janela, aborta
if [ ${#WINDOW_IDS[@]} -eq 0 ]; then
    exit 0
fi

# Se nada estiver focado, foca a primeira
if [ -z "$CURRENT_ID" ]; then
    niri msg action focus-window --id "${WINDOW_IDS[0]}"
    exit 0
fi

# Acha a posição da janela atual na lista
INDEX=-1
for i in "${!WINDOW_IDS[@]}"; do
    if [[ "${WINDOW_IDS[$i]}" == "$CURRENT_ID" ]]; then
        INDEX=$i
        break
    fi
done

# Se não encontrou, foca a primeira
if [ "$INDEX" -eq -1 ]; then
    niri msg action focus-window --id "${WINDOW_IDS[0]}"
    exit 0
fi

# Verifica direção: próxima (default) ou anterior ("prev")
if [[ "$1" == "prev" ]]; then
    # Alt + Shift + Tab → janela anterior (cíclica)
    NEXT_INDEX=$(( (INDEX - 1 + ${#WINDOW_IDS[@]}) % ${#WINDOW_IDS[@]} ))
else
    # Alt + Tab → próxima janela (cíclica)
    NEXT_INDEX=$(( (INDEX + 1) % ${#WINDOW_IDS[@]} ))
fi

NEXT_ID=${WINDOW_IDS[$NEXT_INDEX]}

# Foca a janela escolhida
niri msg action focus-window --id "$NEXT_ID"
