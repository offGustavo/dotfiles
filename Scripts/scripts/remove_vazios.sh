#!/bin/bash

# Arquivo com a lista de conflitos
ARQUIVO="conflitos.txt"

# Verifica se o arquivo existe
if [ ! -f "$ARQUIVO" ]; then
  echo "Arquivo $ARQUIVO não encontrado!"
  exit 1
fi

# Lê cada linha do arquivo
while IFS= read -r linha; do
  # Extrai o caminho entre os dois pontos (:) e antes de "exists"
  caminho=$(echo "$linha" | sed -n 's/^[^:]*: \(.*\) exists in filesystem/\1/p')
  
  # Se encontrou o caminho, remove o arquivo
  if [ -n "$caminho" ]; then
    echo "Removendo: $caminho"
    rm -f "$caminho"
  fi
done < "$ARQUIVO"
