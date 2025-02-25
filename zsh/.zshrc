# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/bin/$PATH
export PATH=$PATH:$HOME/.config/emacs/bin
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
plugins=(git)

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
alias kanata="sudo ~/.config/kanata/kanata -c ~/.config/kanata/kanata.kbd"
alias nitro="sudo ~/.config/kanata/kanata -c ~/.config/kanata/nitro.kbd"
alias keyball39="sudo ~/.config/kanata/kanata -c ~/.config/kanata/keyball39.kbd"
alias exa="exa --icons --git -l -G -h -a"

# neovim fzf inegration
alias vi='nvim $(fzf)'
alias ni='zi && nvim'
alias gengar="pokeget --hide-name gengar| fastfetch --file-raw - -c ~/.config/fastfetch/gengar.jsonc"

# Fastfetch show on startup
eval 'gengar' 

# FZF defaults
#
  # --border=none \
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=rounded \
  --margin=3% \
  --color=bg+:#283457 \
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
  --preview 'if [ -d {} ]; then exa -a -T {}; else bat --color=always {}; fi'
"


  # --preview 'if [ -d {} ]; then exa -a -T {}; else bat --color=always {}; fi'
# --preview='bat --color=always {}'
# --preview='exa -a -T {}'

export FZF_DEFAULT_COMMAND='fd --hidden'

# I LOVE RUST
#
# export FZF_DEFAULT_COMMAND='find .'
# export FZF_DEFAULT_COMMAND='find . -printf "%P\\n"'


# # Nala pacman style commands

alias nala='sudo nala'
# alias 'nala autoupdate'='sudo nala update && sudo nala upgrade'

# nala() {
#   package_name="$2"
#   case "$1" in
#     -S)
#       [[ -n "$package_name" ]] && sudo nala install "$package_name"
#       ;;
#     -s)
#       [[ -n "$package_name" ]] && sudo nala search "$package_name"
#       ;;
#     -Rs)
#       [[ -n "$package_name" ]] && sudo nala remove "$package_name"
#       ;;
#     -Yc)
#       sudo nala autoremove
#       ;;
#     install)
#       [[ -n "$package_name" ]] && sudo nala install "$package_name"
#       ;;
#     remove)
#       [[ -n "$package_name" ]] && sudo nala remove "$package_name"
#       ;;
#     purge)
#       [[ -n "$package_name" ]] && sudo nala purge "$package_name"
#       ;;
#     search)
#       [[ -n "$package_name" ]] && sudo nala search "$package_name"
#       ;;
#     show)
#       [[ -n "$package_name" ]] && sudo nala show "$package_name"
#       ;;
#     list)
#       [[ -n "$package_name" ]] && command nala list "$package_name"
#       ;;
#     history)
#       sudo nala history
#       ;;
#     fetch)
#       sudo nala fetch
#       ;;
#     clean)
#       sudo nala clean
#       ;;
#     autoremove)
#       sudo nala autoremove
#       ;;
#     autopurge)
#       sudo nala autopurge
#       ;;
#     update)
#       sudo nala update
#       ;;
#     upgrade)
#       sudo nala upgrade
#       ;;
#     full-upgrade)
#       sudo nala full-upgrade
#       ;;
#     "")
#       sudo nala update && sudo nala upgrade
#       ;;
#   esac
# }


