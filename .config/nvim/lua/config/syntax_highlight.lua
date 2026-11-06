Fish.highlight_state = false -- true = Treesitter + LSP semantic tokens

local function apply_highlight(buf, enabled)
  local ok
  if not (vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf)) then
    return
  end
  -- skip special buffers (terminal, help, quickfix, etc.)
  if vim.bo[buf].buftype ~= "" then
    return
  end

  vim.api.nvim_buf_call(buf, function()
    -- always stop first so the highlighter is fully restarted
    pcall(vim.treesitter.stop, buf)

    if enabled then
      ok = pcall(vim.treesitter.start, buf)
      if ok then
        vim.cmd("syntax clear") -- buffer-local: drop regex highlight
        vim.lsp.semantic_tokens.enable(true, { bufnr = buf })
        pcall(vim.lsp.semantic_tokens.force_refresh, buf)
      else
        -- no parser for this filetype: fall back to regex syntax
        vim.bo[buf].syntax = vim.bo[buf].filetype
      end
    else
      vim.lsp.semantic_tokens.enable(false, { bufnr = buf })
      -- re-setting 'syntax' re-triggers the Syntax event and reloads regex highlight
      vim.bo[buf].syntax = vim.bo[buf].filetype
    end
  end)

  if ok then
    return true
  end
  return false
end

function _G.toggle_highlight(state)
  local ok
  if state == nil then
    state = not Fish.highlight_state
  end
  Fish.highlight_state = state

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    ok = apply_highlight(buf, state)
  end

  if ok then
    vim.notify("Treesitter + LSP highlight: " .. (state and "on" or "off"))
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    apply_highlight(args.buf, Fish.highlight_state)
  end,
})

-- LSP attaches after the buffer opens, so semantic tokens need a nudge then
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities then
      vim.lsp.semantic_tokens.enable(Fish.highlight_state, { bufnr = args.buf })
    end
  end,
})
