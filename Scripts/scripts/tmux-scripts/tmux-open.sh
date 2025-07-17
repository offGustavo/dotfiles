#!/bin/bash

# Verifica se foi passada a flag --float
if [ "$1" == "--float" ]; then
  FLOAT_MODE=true
  shift # Remove a flag dos argumentos
else
  FLOAT_MODE=false
fi

# Verifica se foi passado o nome do programa
if [ -z "$1" ]; then
  echo "Uso: $0 [--float] <nome_do_programa> [args...]"
  exit 1
fi

PROGRAM="$1"
shift       # Remove o nome do programa dos argumentos
ARGS=("$@") # Armazena argumentos extras em um array

# Pega o diretório atual da janela do tmux
CWD=$(tmux display-message -p -F "#{pane_current_path}")

if [ "$FLOAT_MODE" = true ]; then
  # Abre em uma popup do tmux com argumentos extras
  tmux popup \
    -E \
    -w 90% -h 80% \
    -T "$PROGRAM" \
    -d "$CWD" \
    "$PROGRAM" "${ARGS[@]}"
else
  # Verifica se já existe uma janela com o nome
  if tmux list-windows -F "#{window_name}" | grep -q "^$PROGRAM$"; then
    tmux select-window -t "$PROGRAM"
    exit 0
  fi

  # Cria uma nova janela normal com argumentos extras
  tmux new-window -n "$PROGRAM" -c "#{pane_current_path}" "$PROGRAM" "${ARGS[@]}"
fi
