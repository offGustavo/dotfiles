#!/usr/bin/env lua

-- Função para executar comandos e capturar saída
function run(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	return result
end

-- Função para mostrar menu wofi e capturar seleção
function wofi_menu(prompt, options)
	local input = table.concat(options, "\n")
	local handle = io.popen('wofi --dmenu -p "' .. prompt .. '"', "w")
	handle:write(input)
	handle:close()

	local output = run('wofi --show dmenu -p "' .. prompt .. '" <<< "' .. input .. '"')
	return string.gsub(output, "\n", "")
end

-- Verifica se bluetooth está ligado
function is_power_on()
	local output = run("bluetoothctl show")
	return string.match(output, "Powered: yes") ~= nil
end

-- Liga/desliga bluetooth
function toggle_power()
	if is_power_on() then
		print(toggle_power())
		run("bluetoothctl power off")
	else
		run("bluetoothctl power on")
	end
end

-- Verifica se está escaneando
function is_scan_on()
	local output = run("bluetoothctl show")
	return string.match(output, "Discovering: yes") ~= nil
end

-- Liga/desliga scan
function toggle_scan()
	if is_scan_on() then
		run("bluetoothctl scan off")
	else
		run("bluetoothctl scan on & sleep 5")
	end
end

-- Verifica pairable
function is_pairable_on()
	local output = run("bluetoothctl show")
	return string.match(output, "Pairable: yes") ~= nil
end

function toggle_pairable()
	if is_pairable_on() then
		run("bluetoothctl pairable off")
	else
		run("bluetoothctl pairable on")
	end
end

-- Verifica discoverable
function is_discoverable_on()
	local output = run("bluetoothctl show")
	return string.match(output, "Discoverable: yes") ~= nil
end

function toggle_discoverable()
	if is_discoverable_on() then
		run("bluetoothctl discoverable off")
	else
		run("bluetoothctl discoverable on")
	end
end

-- Verifica se dispositivo está conectado
function is_connected(mac)
	local output = run("bluetoothctl info " .. mac)
	return string.match(output, "Connected: yes") ~= nil
end

-- Verifica se dispositivo está pareado
function is_paired(mac)
	local output = run("bluetoothctl info " .. mac)
	return string.match(output, "Paired: yes") ~= nil
end

-- Verifica se dispositivo está confiável
function is_trusted(mac)
	local output = run("bluetoothctl info " .. mac)
	return string.match(output, "Trusted: yes") ~= nil
end

-- Alterna conexão de dispositivo
function toggle_connection(mac)
	if is_connected(mac) then
		run("bluetoothctl disconnect " .. mac)
	else
		run("bluetoothctl connect " .. mac)
	end
end

-- Alterna pareamento
function toggle_pair(mac)
	if is_paired(mac) then
		run("bluetoothctl remove " .. mac)
	else
		run("bluetoothctl pair " .. mac)
	end
end

-- Alterna trust
function toggle_trust(mac)
	if is_trusted(mac) then
		run("bluetoothctl untrust " .. mac)
	else
		run("bluetoothctl trust " .. mac)
	end
end

-- Submenu para um dispositivo específico
function device_menu(mac, name)
	while true do
		local status_conn = is_connected(mac) and "Connected: yes" or "Connected: no"
		local status_pair = is_paired(mac) and "Paired: yes" or "Paired: no"
		local status_trust = is_trusted(mac) and "Trusted: yes" or "Trusted: no"

		local options = {
			status_conn,
			status_pair,
			status_trust,
			"Back",
			"Exit",
		}

		local choice = wofi_menu(name, options)

		if choice == status_conn then
			toggle_connection(mac)
		elseif choice == status_pair then
			toggle_pair(mac)
		elseif choice == status_trust then
			toggle_trust(mac)
		elseif choice == "Back" or choice == "" then
			main_menu()
		elseif choice == "Exit" then
			os.exit()
		end
	end
end

-- Menu principal
function main_menu()
	while true do
		local devices_output = run("bluetoothctl devices")
		local devices = {}
		local mac_map = {}

		for line in devices_output:gmatch("[^\r\n]+") do
			local mac, name = string.match(line, "Device ([%w:]+) (.+)")
			if mac and name then
				table.insert(devices, name)
				mac_map[name] = mac
			end
		end

		local power = is_power_on() and "Power: on" or "Power: off"
		local scan = is_scan_on() and "Scan: on" or "Scan: off"
		local pairable = is_pairable_on() and "Pairable: on" or "Pairable: off"
		local discoverable = is_discoverable_on() and "Discoverable: on" or "Discoverable: off"

		local options = {}
		for _, d in ipairs(devices) do
			table.insert(options, d)
		end

		table.insert(options, power)
		table.insert(options, scan)
		table.insert(options, pairable)
		table.insert(options, discoverable)
		table.insert(options, "Exit")

		local choice = wofi_menu("Bluetooth", options)

		if choice == power then
			toggle_power()
		elseif choice == scan then
			toggle_scan()
		elseif choice == pairable then
			toggle_pairable()
		elseif choice == discoverable then
			toggle_discoverable()
		elseif choice == "Exit" or choice == "" then
			os.exit()
		elseif mac_map[choice] then
			device_menu(mac_map[choice], choice)
		end
	end
end

-- Executa o menu principal
main_menu()
