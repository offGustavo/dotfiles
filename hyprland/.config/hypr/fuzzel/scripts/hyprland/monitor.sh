#!/bin/bash

# Caminho para o arquivo de configuração principal do Hyprland
HYPR_CONFIG="/home/gustavo/.config/hypr/config/monitors.conf"

# Verifica se o arquivo existe
if [[ ! -f "$HYPR_CONFIG" ]]; then
  echo "Arquivo $HYPR_CONFIG não encontrado!"
  exit 1
fi

# Opções de configuração para os monitores
OPTIONS=(
  "Quarto Acima (HDMI-A-2): HDMI-A-2, 1920x1080@180, 0x-1080, 1.0"
  "Quarto Direita (HDMI-A-2): HDMI-A-2, 1920x1080@180, 1920x0, 1.0"
  "Quarto Esquerda (HDMI-A-2): HDMI-A-2, 1920x1080@180, -1920x0, 1.0"
  "TV Acima (HDMI-A-2): HDMI-A-2, 3840x2160@60, 0x-1080, 2.0"
  "TV Direita (HDMI-A-2): HDMI-A-2, 3840x2160@59.94Hz, 1920x0, 2.0"
  "TV Esquerda (HDMI-A-2): HDMI-A-2, 3840x2160@59.94Hz, -1920x0, 2.0"
  "FATEC (HDMI-A-2): HDMI-A-2, 1920x1080@60, 0x-1080, 1.0"
  "Ativar eDP-1: eDP-1, 1920x1080@60, 0x0, 1.0"
  "Desativar eDP-1: eDP-1, disable"
)

# Gera o menu usando Rofi
CHOICE=$(printf '%s\n' "${OPTIONS[@]}" | fuzzel -d --config $HOME/.config/hypr/fuzzel/fuzzel.ini -p "Monitors")

echo $CHOICE

# Verifica se houve escolha
if [[ -z "$CHOICE" ]]; then
  echo "Nenhuma configuração selecionada. Saindo."
  exit 0
fi

# Extrai o monitor e a configuração selecionados
SELECTED_MONITOR=$(echo "$CHOICE" | cut -d';' -f2 | grep -oE "HDMI-A-2|eDP-1")
SELECTED_CONFIG="monitor = ${CHOICE#*: }"

# Modifica o arquivo de configuração, apenas para o monitor selecionado
awk -v monitor="$SELECTED_MONITOR" -v new_config="$SELECTED_CONFIG" '
    BEGIN { inside_monitor_block = 0 }
    # Entra no bloco do monitor selecionado
    $0 ~ "^monitor\\s*=\\s*" monitor {
        inside_monitor_block = 1
        if (new_config != "") print new_config
        next
    }
    # Sai do bloco do monitor
    inside_monitor_block && !/^#/ && /^[^ \t]/ {
        inside_monitor_block = 0
    }
    !inside_monitor_block { print }
' "$HYPR_CONFIG" >"${HYPR_CONFIG}.tmp" && mv "${HYPR_CONFIG}.tmp" "$HYPR_CONFIG"

echo "Configuração aplicada com sucesso para o monitor $SELECTED_MONITOR!"
