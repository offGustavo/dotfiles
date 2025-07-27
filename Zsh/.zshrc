# I you come from bash you might have to change your $PATH.
export XDG_CONFIG_HOME="$HOME/.config"
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/bin/$PATH
export PATH=$PATH:$HOME/scripts
export PATH=$PATH:$HOME/.config/emacs/bin

# Fix java lsp
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH=$JAVA_HOME/bin:$PATH

# Start Emacs daemon if it's not running
if ! pgrep -x "emacs" >/dev/null; then
  emacs --daemon
fi

# Use neovim as manpager
export MANPAGER='nvim +Man!'

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell" # set by `omz`

ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "josh" "smt" "example")

# Init Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Init Zoxide/Z
eval "$(zoxide init zsh)"

# Init Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR='emacs -nw'

# Example aliases
alias zconf="$EDITOR ~/.zshrc"

# Eza is hard to type
alias exa="eza --icons --git -l -G -h -a"

# Zoxide
alias cd=z

# Emacs shit
alias emacs='emacs -nw'

# Gengar Fastfetch
alias :g="pokeget --hide-name gengar | fastfetch --file-raw - -c ~/.config/fastfetch/gengar.jsonc"
alias gengar="pokeget --hide-name gengar | fastfetch --file-raw - -c ~/.config/fastfetch/gengar.jsonc"

# Exit terminal
alias :q=exit

# Edit File
alias :e=$EDITOR

# Edit File in Vim
alias :E=nvim

# Fastfetch show on startup
if command -v fastfetch >/dev/null 2>&1; then
  eval gengar
fi

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=rounded \
  --style=full \
  --margin=3% \
  --color=bg+:#1a1b26 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
  --preview 'if [ -d {} ]; then eza --icons --git -l -G -h  -l --icons {}; else fzf-preview.sh {}; fi' \
  --preview-window down \
  --multi  \
  --bind ctrl-q:toggle-all,alt-q:toggle-all \
  --bind ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up
      "

export FZF_DEFAULT_COMMAND='fd --hidden'
