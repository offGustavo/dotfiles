# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/bin/$PATH
export PATH=$PATH:$HOME/Scripts
export XDG_CONFIG_HOME="$HOME/.config"

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
plugins=(git vi-mode tmux)

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
alias exa="exa --icons --git -l -G -h -a"

# Edit File with Sudo
alias svim='sudoedit'

# neovim fzf inegration

alias :v='nvim $(fzf)'
# alias vi='nvim $(fzf)'
alias :vf='zi && nvim'
alias ni='zi && nvim'
alias mi='SESSION=$(command zoxide query -s -l | fzf --preview "command exa -l {}") && SESSION=$(echo ${SESSION} | awk $SESSION_PRINT) && __zoxide_cd "$SESSION" && SESSION=$(basename "$SESSION") && (tmux has-session -t "$SESSION" 2>/dev/null && tmux attach-session -t "$SESSION" || tmux new-session -s "$SESSION" nvim)'
alias :s='SESSION=$(command zoxide query -s -l | fzf --preview "command exa -l {}") && SESSION=$(echo ${SESSION} | awk $SESSION_PRINT) && __zoxide_cd "$SESSION" && SESSION=$(basename "$SESSION") && (tmux has-session -t "$SESSION" 2>/dev/null && tmux attach-session -t "$SESSION" || tmux new-session -s "$SESSION" nvim)'
alias :sf="zi && tmux"
alias ci="zi && tmux"
alias :vl="tmux new-session nvim"
alias pi="tmux new-session nvim"
# --style=minimal --no-border --no-margin
alias :S='tmux attach -t $(tmux list-session -F "#{session_name}" | fzf --no-preview )'
alias ti='tmux attach -t $(tmux list-session -F "#{session_name}" | fzf --no-preview )'

# lunarvim config
LVIM='NVIM_APPNAME=lvim nvim'
alias lvim=$LVIM
alias :L=$LVIM
# clean tmux config
alias :S="tmux -f ~/.config/cmux/cmux.conf"
alias cmux="tmux -f ~/.config/cmux/cmux.conf"

alias :Ls="tmux -f ~/.config/cmux/cmux.conf new-session -s vim '$LVIM nvim'"

# Gengar Fastfetch
alias :g="pokeget --hide-name gengar | fastfetch --file-raw - -c ~/.config/fastfetch/gengar.jsonc"
alias gengar="pokeget --hide-name gengar | fastfetch --file-raw - -c ~/.config/fastfetch/gengar.jsonc"

# Exit terminal
alias :q=exit

# Edit File in Vim
alias :e=vim

# Edit File in Neovim
alias :E=nvim

# Nala aliases
alias nala='sudo nala'
alias 'nala autoupdate'='sudo nala update && sudo nala upgrade'

# Fastfetch show on startup
# eval 'colorscript -r'
eval 'gengar'   

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
    --preview 'if [ -d {} ]; then exa -a -l --icons {}; else fzf-preview.sh {}; fi' \
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


##############
### KEYMAP ###
##############

# Map Alt+o to create a new tmux session with zoxide directory picker
SESSION_PRINT='{print $2}'
bindkey -s '^[o' 'SESSION=$(command zoxide query -s -l | fzf --preview "command exa -l {}") && SESSION=$(echo ${SESSION} | awk $SESSION_PRINT) && __zoxide_cd "$SESSION" && SESSION=$(basename "$SESSION") && (tmux has-session -t "$SESSION" 2>/dev/null && tmux attach-session -t "$SESSION" || tmux new-session -s "$SESSION" nvim)\n'
# Map Alt+u to picker open tmux session with fzf
bindkey -s '^[u' 'SESSION=$(tmux list-sessions -F "#{session_name}" | fzf --no-preview) && [ -n "$SESSION" ] && tmux attach -t "$SESSION"\n'

