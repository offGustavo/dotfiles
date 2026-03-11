if true then return {} end
return {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    -- enabled = false,
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
        { "]t",         function() require("todo-comments").jump_next() end,              desc = "Next Todo Comment" },
        { "[t",         function() require("todo-comments").jump_prev() end,              desc = "Previous Todo Comment" },
        { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                                   desc = "Todo (Trouble)" },
        { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
        { "<leader>st", "<cmd>TodoFzfLua<cr>",                                            desc = "Todo" },
        { "<leader>sT", "<cmd>TodoFzfLua keywords=TODO,FIX,FIXME<cr>",                    desc = "Todo/Fix/Fixme" },
    },
}
