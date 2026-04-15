-- pcall(function() require('snacks').zen() end)
vim.schedule(
    function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        -- vim.cmd.normal({ args = { 'L' }, bang = true })
    end
)
pcall(vim.keymap.del, 'n', 'q', { buffer = true })
vim.keymap.set('n', 'q',
    function()
        -- pcall(function() require('snacks').zen() end)
        vim.cmd('quit')
    end, { buffer = true, silent = true }
)
