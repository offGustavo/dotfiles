# Neovim(Vim) Configuration

## Init.lua

### Leader and Local Leader
First we map the leader keys, <space> to global leader and <M-m> to local leader

```lua
vim.g.mapleader = "<space>"
vim.g.maplocalleader = "<M-m>"
```

But what are the differences between these two?

On the <leader> key you us can map thing like you fuzzy finder, for example:

```vim
nmap <leader><space> :find 
" Or 
nmap <leader>ff :FzfLua files<CR>
```

On the <localleader> you can map things like ftplugin keymaps, so you have a keymaps to run a line of lua in the lua ftplugin, map this to 

```vim
nmap <localleader>l :.lua<Cr>
```

So with this you keep <leader>l free to keymaps for location list(or any shortcut you like to use)

### Autocmds

    ```lua
    vim.autocmd = vim.nvim_api.autocmd
    vim.doautocmd = vim.nvim_api.doautocmd
    ```


### Global 

    You can make state global in neovim
    ```lua
    _G.Fish = {}
    function _G.my_func() 
do_something()
    end
    ```

### Theme

    ```
    -- Set Theme
    require("fish.theme")
    ```
