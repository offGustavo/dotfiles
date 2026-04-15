#!/usr/bin/env lua

local waybar_mode = false

-- Parse command line arguments
for i, arg in ipairs(arg) do
    if arg == "--waybar" then
        waybar_mode = true
        -- table.remove(arg, i)
        break
    end
end

-- Função para executar comandos e capturar saída
local function exec_cmd(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result:gsub("^%s*(.-)%s*$", "%1")  -- Remove espaços extras
end

-- Função para executar comandos com entrada
local function exec_cmd_with_input(cmd, input)
    local handle = io.popen(cmd, "w")
    handle:write(input)
    handle:close()
end

-- Configurar comando fuzzel baseado no modo waybar
local fuzzel_command
if waybar_mode then
    fuzzel_command = "fuzzel -a top-right -w 30 -l 10 --x-margin 10 -d -p "
else
    fuzzel_command = "fuzzel -d -p "
end

-- Obter informações das conexões de rede usando nmcli
local function get_network_info()
    local connections = {}
    local active_connections = {}
    
    -- Obter conexões ativas
    local active_output = exec_cmd("nmcli -t -f TYPE,CONNECTION,DEVICE connection show --active")
    for line in active_output:gmatch("[^\n]+") do
        local type, name, device = line:match("([^:]*):([^:]*):([^:]*)")
        if name and name ~= "" then
            active_connections[name] = {
                type = type,
                device = device,
                active = true
            }
        end
    end
    
    -- Obter todas as conexões
    local all_output = exec_cmd("nmcli -t -f TYPE,NAME connection show")
    for line in all_output:gmatch("[^\n]+") do
        local type, name = line:match("([^:]*):([^:]*)")
        if name and name ~= "" then
            local is_active = active_connections[name] ~= nil
            table.insert(connections, {
                name = name,
                type = type,
                active = is_active
            })
        end
    end
    
    return connections, active_connections
end

-- Obter redes Wi-Fi disponíveis
local function get_wifi_networks()
    local networks = {}
    
    -- Verificar se Wi-Fi está ativado
    local wifi_status = exec_cmd("nmcli radio wifi")
    if wifi_status:match("disabled") then
        return networks
    end
    
    -- Obter redes Wi-Fi
    local wifi_output = exec_cmd("nmcli -t -f SSID,SIGNAL,SECURITY device wifi list")
    for line in wifi_output:gmatch("[^\n]+") do
        local ssid, signal, security = line:match("([^:]*):([^:]*):([^:]*)")
        if ssid and ssid ~= "" then
            -- Verificar se está conectado a esta rede
            local connected = false
            local connected_output = exec_cmd("nmcli -t -f SSID connection show --active")
            for conn_line in connected_output:gmatch("[^\n]+") do
                if conn_line == ssid then
                    connected = true
                    break
                end
            end
            
            table.insert(networks, {
                ssid = ssid,
                signal = tonumber(signal) or 0,
                security = security or "--",
                connected = connected
            })
        end
    end
    
    return networks
end

-- Função para conectar a uma rede Wi-Fi
local function connect_to_wifi(ssid)
    -- Verificar se a rede já está salva
    local saved_output = exec_cmd("nmcli -t -f NAME connection show")
    local already_saved = false
    for line in saved_output:gmatch("[^\n]+") do
        if line == ssid then
            already_saved = true
            break
        end
    end
    
    if already_saved then
        -- Conectar à rede salva
        exec_cmd("nmcli connection up \"" .. ssid .. "\"")
    else
        -- Solicitar senha e criar nova conexão
        local prompt = fuzzel_command .. "\"Senha para " .. ssid .. ":\" --password"
        local password = exec_cmd("echo '' | " .. prompt)
        if password and password ~= "" then
            exec_cmd("nmcli device wifi connect \"" .. ssid .. "\" password \"" .. password .. "\"")
        end
    end
end

-- Função para ativar/desativar conexão
local function toggle_connection(connection_name)
    local connections, active_connections = get_network_info()
    
    for _, conn in ipairs(connections) do
        if conn.name == connection_name then
            if conn.active then
                exec_cmd("nmcli connection down \"" .. connection_name .. "\"")
            else
                exec_cmd("nmcli connection up \"" .. connection_name .. "\"")
            end
            break
        end
    end
end

-- Função para ativar/desativar Wi-Fi
local function toggle_wifi()
    local status = exec_cmd("nmcli radio wifi")
    if status:match("enabled") then
        exec_cmd("nmcli radio wifi off")
    else
        exec_cmd("nmcli radio wifi on")
    end
end

-- Função para abrir editor de conexões
local function open_connection_editor()
    -- Verificar se nm-connection-editor está disponível
    local handle = io.popen("which nm-connection-editor 2>/dev/null")
    local result = handle:read("*a")
    handle:close()
    
    if result and result ~= "" then
        exec_cmd("nm-connection-editor &")
    else
        -- Tentar usar nmtui
        exec_cmd("alacritty -e nmtui &")
    end
end

-- Função para deletar conexão
local function delete_connection(connection_name)
    exec_cmd("nmcli connection delete \"" .. connection_name .. "\"")
end

-- Função principal para mostrar menu
local function show_menu()
    local menu_items = {}
    local connections, active_connections = get_network_info()
    local wifi_networks = get_wifi_networks()
    
    -- Adicionar seção de redes Wi-Fi
    if #wifi_networks > 0 then
        table.insert(menu_items, "=== Redes Wi-Fi ===")
        for _, network in ipairs(wifi_networks) do
            local prefix = network.connected and "✓ " or "  "
            local signal_bars = ""
            local signal = tonumber(network.signal) or 0
            
            -- Criar barras de sinal baseadas na força do sinal
            if signal > 75 then
                signal_bars = "▂▄▆█"
            elseif signal > 50 then
                signal_bars = "▂▄▆ "
            elseif signal > 25 then
                signal_bars = "▂▄  "
            else
                signal_bars = "▂   "
            end
            
            local item = string.format("%s%s (%s) [%d%% %s]", 
                prefix, network.ssid, network.security, signal, signal_bars)
            table.insert(menu_items, item)
        end
        table.insert(menu_items, "")
    end
    
    -- Adicionar seção de conexões salvas
    if #connections > 0 then
        table.insert(menu_items, "=== Conexões Salvas ===")
        for _, conn in ipairs(connections) do
            local prefix = conn.active and "✓ " or "  "
            local item = string.format("%s%s (%s)", prefix, conn.name, conn.type)
            table.insert(menu_items, item)
        end
        table.insert(menu_items, "")
    end
    
    -- Adicionar ações
    table.insert(menu_items, "=== Ações ===")
    table.insert(menu_items, "Ativar/Desativar Wi-Fi")
    table.insert(menu_items, "Abrir Editor de Conexões")
    table.insert(menu_items, "Sair")
    
    -- Criar menu
    local menu_text = table.concat(menu_items, "\n")
    local selected = exec_cmd("echo \"" .. menu_text .. "\" | " .. fuzzel_command .. "\"Gerenciador de Rede:\"")
    
    if not selected or selected == "" then
        return
    end
    
    -- Processar seleção
    selected = selected:gsub("^%s*(.-)%s*$", "%1")  -- Trim whitespace
    
    if selected == "Sair" then
        return
    elseif selected == "Ativar/Desativar Wi-Fi" then
        toggle_wifi()
    elseif selected == "Abrir Editor de Conexões" then
        open_connection_editor()
    else
        -- Verificar se é uma rede Wi-Fi
        for _, network in ipairs(wifi_networks) do
            local pattern = "^[✓ ]?" .. network.ssid:gsub("([%%%.%+%-%*%?%^%$%(%)%[%]%{%}])", "%%%1")
            if selected:match(pattern) then
                connect_to_wifi(network.ssid)
                return
            end
        end
        
        -- Verificar se é uma conexão salva
        for _, conn in ipairs(connections) do
            local pattern = "^[✓ ]?" .. conn.name:gsub("([%%%.%+%-%*%?%^%$%(%)%[%]%{%}])", "%%%1")
            if selected:match(pattern) then
                toggle_connection(conn.name)
                return
            end
        end
    end
end

-- Função para mostrar status (para waybar/polybar)
local function show_status()
    local connections, active_connections = get_network_info()
    
    -- Verificar conexão ativa
    for name, info in pairs(active_connections) do
        if info.type == "802-11-wireless" then
            print(" " .. name)
            return
        elseif info.type == "802-3-ethernet" then
            print(" " .. name)
            return
        end
    end
    
    -- Se não houver conexão ativa
    print(" Offline")
end

-- Processar argumentos
if #arg > 0 then
    if arg[1] == "--status" then
        show_status()
    else
        show_menu()
    end
else
    show_menu()
end
