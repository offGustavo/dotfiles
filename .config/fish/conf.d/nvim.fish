function n
  NVIM_APPNAME=$argv nvim
end

alias lvim="NVIM_APPNAME=lvim nvim"
alias lazyvim="NVIM_APPNAME=lazyvim nvim"
alias mini="NVIM_APPNAME=nvim-minimax nvim"

alias fzf-lua="nvim -l ~/.local/share/nvim/lazy/fzf-lua/scripts/cli.lua"
