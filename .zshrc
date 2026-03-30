# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/histfile
HISTSIZE=10000
SAVEHIST=1000
setopt autocd notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/gustavo/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(zoxide init zsh)"

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"

# alias vim=nvim
export EDITOR=nvim

# Dotfiles
alias dot='/usr/bin/env git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME"'

# Keyboard
# cat /proc/bus/input/devices | rg --context 10 "Translated"
alias kboff="sudo echo 1 | sudo tee /sys/class/input/event0/device/inhibited"
alias kbon="sudo echo 0 | sudo tee /sys/class/input/event0/device/inhibited"

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/home/gustavo/.local/share/bob/nvim-bin
