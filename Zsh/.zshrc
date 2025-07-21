# I you come from bash you might have to change your $PATH.
export XDG_CONFIG_HOME="$HOME/.config"
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/bin/$PATH
export PATH=$PATH:$HOME/scripts
# export PATH=$PATH:$HOME/.config/emacs/bin

# Fix java lsp
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH=$JAVA_HOME/bin:$PATH


# Use neovim as manpager
export MANPAGER='nvim +Man!'

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="random" # set by `omz`

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "josh" "smt" "example")

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(vi-mode)

# Init Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Init Zoxide/Z
eval "$(zoxide init zsh)"

# Init Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.

#
# Example aliases
alias zconf="$EDITOR ~/.zshrc"
alias ohmyzshinstall='sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"'

# Eza is hard to type
alias exa="eza --icons --git -l -G -h -a"

# Emacs shit
alias :em='emacsclient -c -a ""'
alias :et='emacsclient -t -a ""'
alias :en='emacs -nw ""'

# Edit File with Sudo
alias svim='sudoedit'
alias :se='sudoedit'

# neovim fzf inegration

alias :v='nvim $(fzf)'
# alias vi='nvim $(fzf)'
alias :vf='zi && nvim'
alias ni='zi && nvim'
alias mi='SESSION=$(command zoxide query -s -l | fzf --preview "command eza -l {}") && SESSION=$(echo ${SESSION} | awk $SESSION_PRINT) && __zoxide_cd "$SESSION" && SESSION=$(basename "$SESSION") && (tmux has-session -t "$SESSION" 2>/dev/null && tmux attach-session -t "$SESSION" || tmux new-session -s "$SESSION")'
alias :s='SESSION=$(command zoxide query -s -l | fzf --preview "command eza -l {}") && SESSION=$(echo ${SESSION} | awk $SESSION_PRINT) && __zoxide_cd "$SESSION" && SESSION=$(basename "$SESSION") && (tmux has-session -t "$SESSION" 2>/dev/null && tmux attach-session -t "$SESSION" || tmux new-session -s "$SESSION")'
alias :sf="zi && tmux"
alias ci="zi && tmux"
alias :vl="tmux new-session nvim"
alias pi="tmux new-session nvim"
# --style=minimal --no-border --no-margin
alias :S='tmux attach -t $(tmux list-session -F "#{session_name}" | fzf --no-preview )'
alias ti='tmux attach -t $(tmux list-session -F "#{session_name}" | fzf --no-preview )'

# # lunarvim config
LVIM='NVIM_APPNAME=lvim nvim'
alias lvim=$LVIM
alias :L=$LVIM

# minimal tmux config
alias :c="tmux -f ~/.config/cmux/cmux.conf"
alias cmux="tmux -f ~/.config/cmux/cmux.conf"
alias :Lc="tmux -f ~/.config/cmux/cmux.conf new-session -s vim '$LVIM nvim'"

# Gengar Fastfetch
alias :g="pokeget --hide-name gengar | fastfetch --file-raw - -c ~/.config/fastfetch/gengar.jsonc"
alias gengar="pokeget --hide-name gengar | fastfetch --file-raw - -c ~/.config/fastfetch/gengar.jsonc"

# Exit terminal
alias :q=exit

# Edit File
alias :e=$EDITOR

# Edit File in Vim
alias :E=vim

# Nala aliases
alias nala='sudo nala'
alias 'nala autoupdate'='sudo nala update && sudo nala upgrade'

# Fastfetch show on startup
if command -v fastfetch >/dev/null 2>&1; then
    eval gengar
fi

####################
### FZF defaults ###
####################

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


# --border=none \
# --border=rounded \
# --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all  \
# --preview ''
# --preview 'if [ -d {} ]; then exa -a -T {}; else fzf-preview.sh {} {}; fi'
# --preview 'if [ -d {} ]; then exa -a -T {}; else bat --color=always {}; fi'
# --preview='bat --color=always {}'
# --preview='exa -a -T {}'

export FZF_DEFAULT_COMMAND='fd --hidden'
# export FZF_DEFAULT_COMMAND='find .'
# export FZF_DEFAULT_COMMAND='find . -printf "%P\\n"'
# export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --preview='tree {}'"
#
# export _ZO_FZF_OPTS="$_ZO_FZF_OPTS --style=minimal --preview='tree $(echo {} | awk -F'\t' '{print $2}')'"


##################
### FUNCTIONS  ###
##################

# tmux_open() {
#   # Optional program to run in tmux, default to a clean session
#   local prog="${1:-}"
#
#   # Ask for directory with zoxide + fzf
#   local session
#   session=$(zoxide query -s -l | fzf --no-preview) || return
#
#   # Extract base directory name for tmux session name
#   session_name=$(basename "$session")
#
#   # Change directory
#   __zoxide_cd "$session"
#
#   # Check if tmux session exists
#   if tmux has-session -t "$session_name" 2>/dev/null; then
#     # Attach to existing session
#     tmux attach-session -t "$session_name"
#   else
#     # Start a new tmux session with or without a program
#     if [[ -n "$prog" ]]; then
#       tmux new-session -s "$session_name" "$prog"
#     else
#       tmux new-session -s "$session_name"
#     fi
#   fi
# }

tmux_attach() {
  # Get a session name from fzf
  local session
  session=$(tmux list-sessions -F "#{session_name}" | fzf --no-preview) || return

  # If a session was selected, attach to it
  if [[ -n "$session" ]]; then
    tmux attach -t "$session"
  fi
}

##############
### KEYMAP ###
##############

# Map Alt+o to create a new tmux session with zoxide directory picker
bindkey -s '^[o' 'tmux-sessionizer.sh\n'

# Map Alt+u to picker open tmux session with fzf
bindkey -s '^[u' 'tmux_attach\n'

# bindkey -s '^[c' 'FZF_CD_DIR=$(eza -A -D | fzf --preview "command eza -l --color --icons {}") && cd "${FZF_CD_DIR}"\n'
bindkey -s '^[R' 'omz reload\n'

