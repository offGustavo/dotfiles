#!/usr/bin/env lua

local wallpapers = {
	Light = {
		{
			name = "Tokyo Night (day)",
			path = "/home/gustavo/Pictures/Wallpapers/dharmx-Walls/anime/vinland-saga-manga-5120x2880-14832.jpg",
		},
	},
	Dark = {
		-- {
		-- 	name = "Compline",
		-- 	path = "/home/gustavo/Pictures/Wallpapers/my/compline.png",
		-- },
		{
			name = "A Girl with Purple Flowers",
      path = "/home/gustavo/Pictures/Wallpapers/dharmx-Walls/anime/a_cartoon_of_a_girl_standing_under_a_tree_with_purple_flowers.png",
		},

		{
			name = "Tokyo Night",
			path = "/home/gustavo/Pictures/Wallpapers/tokyo-nigth-wallpapers/night/os/arch_01_1920x1080.png",
		},
	},
}

-- Função para verificar e matar processos
local function kill_swaybg_if_running()
	local handle = io.popen("pgrep -x swaybg 2>/dev/null")
	local result = handle:read("*a")
	handle:close()

	if result and result ~= "" then
		os.execute("killall swaybg 2>/dev/null")
		-- Esperar um pouco para garantir que o processo terminou
		os.execute("sleep 0.1")
	end
end

-- Função para detectar o tema do sistema
local function get_system_theme()
	-- Tente detectar tema via GNOME/GTK
	local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || echo 'prefer-light'")
	local gsettings_output = handle:read("*l")
	handle:close()

	if gsettings_output then
		if string.find(gsettings_output, "dark") or string.find(gsettings_output, "'dark'") then
			return "Dark"
		elseif string.find(gsettings_output, "light") or string.find(gsettings_output, "'light'") then
			return "Light"
		end
	end

	-- Tente detectar tema via sway/wayland
	local handle2 = io.popen("swaymsg -t get_inputs 2>/dev/null | grep -i theme || echo ''")
	local sway_output = handle2:read("*a")
	handle2:close()

	if string.find(sway_output:lower(), "dark") then
		return "Dark"
	end

	-- Fallback baseado na hora do dia
	local hour = tonumber(os.date("%H"))
	if hour >= 18 or hour < 6 then
		return "Dark"
	else
		return "Light"
	end
end

-- Função para obter um wallpaper aleatório
local function get_random_wallpaper(theme)
	if not wallpapers[theme] or #wallpapers[theme] == 0 then
		-- Fallback para o outro tema se o tema atual não tiver wallpapers
		local alt_theme = (theme == "Light") and "Dark" or "Light"
		if wallpapers[alt_theme] and #wallpapers[alt_theme] > 0 then
			theme = alt_theme
		else
			return nil, "No wallpapers available for any theme"
		end
	end

	local theme_wallpapers = wallpapers[theme]
	local random_index = math.random(1, #theme_wallpapers)

	return theme_wallpapers[random_index].path, theme_wallpapers[random_index].name
end

-- Função para obter wallpaper por nome
local function get_wallpaper_by_name(name, theme)
	-- Primeiro tenta no tema especificado
	if wallpapers[theme] then
		for _, wp in ipairs(wallpapers[theme]) do
			if wp.name:lower() == name:lower() then
				return wp.path, wp.name
			end
		end
	end

	-- Se não encontrou, procura em todos os temas
	for _, theme_wallpapers in pairs(wallpapers) do
		for _, wp in ipairs(theme_wallpapers) do
			if wp.name:lower() == name:lower() then
				return wp.path, wp.name
			end
		end
	end

	return nil, "Wallpaper not found: " .. name
end

-- Função principal para obter wallpaper
local function get_wallpaper(name)
	local theme = get_system_theme()

	if name then
		local path, wp_name = get_wallpaper_by_name(name, theme)
		if path then
			return path, wp_name, theme
		else
			print("Warning: " .. wp_name .. ". Using random wallpaper instead.")
		end
	end

	local path, wp_name = get_random_wallpaper(theme)
	return path, wp_name, theme
end

-- Função para iniciar swaybg
local function start_swaybg(wallpaper_path)
	if not wallpaper_path then
		print("Error: No wallpaper path provided")
		return false
	end

	-- Verifica se o arquivo existe
	local file = io.open(wallpaper_path, "r")
	if not file then
		print("Error: Wallpaper file not found: " .. wallpaper_path)
		return false
	end
	file:close()

	-- -- Mata o swaybg se estiver rodando
	-- kill_swaybg_if_running()

	-- Inicia o swaybg com o wallpaper
	local cmd = "swaybg -i '" .. wallpaper_path .. "' -m fill &"
	print("Starting swaybg with: " .. wallpaper_path)
	os.execute(cmd)

	return true
end

-- Função para listar wallpapers disponíveis
local function list_wallpapers()
	print("Available wallpapers:")
	for theme, theme_wallpapers in pairs(wallpapers) do
		print("\n" .. theme .. " Theme:")
		for i, wp in ipairs(theme_wallpapers) do
			print(string.format("  %d. %s", i, wp.name))
		end
	end
end

-- Função para adicionar um novo wallpaper
local function add_wallpaper(name, path, theme)
	theme = theme or "Light"

	if not wallpapers[theme] then
		wallpapers[theme] = {}
	end

	table.insert(wallpapers[theme], {
		name = name,
		path = path,
	})

	print("Added wallpaper: " .. name .. " to " .. theme .. " theme")
end

-- Função principal
local function main()
	-- Inicializa random seed
	math.randomseed(os.time())

	-- Parse arguments
	local name = nil
	local list = false
	local add = false
	local add_theme = "Light"
	local add_path = nil

	for i = 1, #arg do
		if arg[i] == "--list" or arg[i] == "-l" then
			list = true
		elseif arg[i] == "--name" or arg[i] == "-n" then
			name = arg[i + 1]
		elseif arg[i] == "--add" or arg[i] == "-a" then
			add = true
			name = arg[i + 1]
			add_path = arg[i + 2]
		elseif arg[i] == "--theme" or arg[i] == "-t" then
			add_theme = arg[i + 1]
		elseif arg[i] == "--help" or arg[i] == "-h" then
			print("Usage: " .. arg[0] .. " [OPTIONS]")
			print("Options:")
			print("  -l, --list              List all available wallpapers")
			print("  -n, --name NAME         Use wallpaper with specific name")
			print("  -a, --add NAME PATH     Add a new wallpaper")
			print("  -t, --theme THEME       Specify theme when adding (Light/Dark)")
			print("  -h, --help              Show this help message")
			print("")
			print("Examples:")
			print("  " .. arg[0] .. "                    # Use random wallpaper based on system theme")
			print("  " .. arg[0] .. ' -n "White mountain"  # Use specific wallpaper')
			print("  " .. arg[0] .. ' -a "New Wall" /path/to/image.jpg -t Dark')
			return
		end
	end

	if list then
		list_wallpapers()
		return
	end

	if add then
		if not name or not add_path then
			print("Error: --add requires name and path arguments")
			return
		end
		add_wallpaper(name, add_path, add_theme)
		return
	end

	-- Obtém o wallpaper
	local wallpaper_path, wallpaper_name, theme = get_wallpaper(name)

	if wallpaper_path then
		print("Selected wallpaper: " .. wallpaper_name)
		print("Theme: " .. theme)
		print("Path: " .. wallpaper_path)

		-- Inicia o swaybg
		if start_swaybg(wallpaper_path) then
			print("Wallpaper set successfully!")
		end
	else
		print("Error: Could not get wallpaper")
	end
end

-- Executa o programa
main()
