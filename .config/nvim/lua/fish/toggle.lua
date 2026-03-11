local M = {}

local dir = {
	{ "on", "off" },
	{ "true", "false" },
	{ "yes", "no" },
	{ "public", "private", "protected" },
}

M.toggle = function()
	-- Salva a posição atual do cursor
	local pos = vim.fn.getpos(".")
	local linha_atual = pos[2]
	local coluna_atual = pos[3] - 1 -- 0-based column

	-- Pega a palavra atual sob o cursor
	local palavra_atual = vim.fn.expand("<cword>")
	if palavra_atual == "" then
		return
	end

	-- Pega a linha completa
	local linha = vim.fn.getline(".")

	-- Procura em cada grupo
	for _, grupo in ipairs(dir) do
		-- Verifica se a palavra atual está neste grupo
		for i, palavra in ipairs(grupo) do
			if palavra == palavra_atual then
				-- Pega a próxima palavra (ou a primeira se for a última)
				local proxima_palavra = grupo[i % #grupo + 1]

				-- Substitui apenas a palavra atual na linha
				-- Usa padrão literal com % para escapar caracteres especiais
				local pattern = palavra_atual:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1")
				local nova_linha = linha:gsub("(%f[%a_]" .. pattern .. "%f[%A_])", proxima_palavra, 1)

				-- Atualiza a linha
				vim.fn.setline(".", nova_linha)

				-- Ajusta o cursor para o final da nova palavra
				local nova_coluna = coluna_atual - #palavra_atual + #proxima_palavra + 1
				vim.fn.cursor(linha_atual, nova_coluna)

				return
			end
		end
	end
end

return M
