#!/usr/bin/env lua

-- Função para executar um comando e retornar sua saída (string)
local function exec(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

-- Obtém o JSON das janelas
local windows_json = exec("niri msg -j windows")
if windows_json == "" or windows_json == nil then
    print("Erro: não foi possível obter a lista de janelas do niri.")
    os.exit(1)
end

-- Usa jq para gerar uma lista no formato: id\tTítulo

local list_cmd = string.format([[echo '%s' | jq -r '.[] | "\(.id)\t\(.title)"' ]], windows_json)
local window_list = exec(list_cmd)
if window_list == "" then
    print("Nenhuma janela encontrada.")
    os.exit(0)
end

-- Cria um arquivo temporário com a lista
local tmp_file = os.tmpname()
local file = io.open(tmp_file, "w")
if not file then
    print("Erro ao criar arquivo temporário.")
    os.exit(1)
end
file:write(window_list)
file:close()

-- Executa rofi dmenu, lendo do arquivo temporário
-- -sep $'\t' define o TAB como separador; -columns 2 mostra duas colunas
local rofi_cmd = string.format("rofi -dmenu -sep $'\\t' -columns 2 -i -p 'Focus window:' < %s", tmp_file)
local selected = exec(rofi_cmd)

-- Remove o arquivo temporário
os.remove(tmp_file)

-- Se o usuário cancelou, sair
if selected == "" or selected == nil then
    os.exit(0)
end

-- Extrai o ID (primeiro campo separado por TAB)
local window_id = selected:match("^([^\t]+)")
if not window_id then
    print("Erro: não foi possível extrair o ID da janela.")
    os.exit(1)
end

-- Foca a janela escolhida
os.execute(string.format("niri msg action focus-window --id %s", window_id))
