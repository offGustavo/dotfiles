# source /usr/share/cachyos-fish-config/cachyos-config.fish

zoxide init fish | source

function zoxide_cd
    set -l use_fuzzel 0

    # if string match -qi "*Hyprland*" "$XDG_CURRENT_DESKTOP"
    #     set use_fuzzel 1
    # end
    #
    # if test $use_fuzzel -eq 1
        set -l dir (zoxide query -l | fuzzel --dmenu)
    # else
        # set -l dir (zoxide query -l | fzf)
    # end

    if test -n "$dir"
        commandline "cd '$dir'"
        commandline -f execute
    end
end

bind -a alt-z zoxide_cd

# bind -a alt-z zi

# # Set and configure VI Mode
# fish_vi_key_bindings
fish_default_key_bindings
#
# # Ctrl-A / Ctrl-E
# bind -M insert \ca beginning-of-line
# bind -M insert \ce end-of-line
#
# bind -M normal \ca beginning-of-line
# bind -M normal \ce end-of-line
#
# # Kill / yank
# bind -M insert \ck kill-line
# bind -M insert \cy yank
# bind -M insert \cw backward-kill-word
# bind -M insert \cu kill-whole-line
# bind -M normal \ck kill-line
# bind -M normal \cy yank
# bind -M normal \cw backward-kill-word
# bind -M normal \cu kill-whole-line
#
# # Cursor movement
# bind -M insert \cb backward-char
# bind -M insert \cf forward-char
# bind -M normal \cb backward-char
# bind -M normal \cf forward-char
#
# bind -e \cp
# bind -e \cn
# bind -M normal \cp up-or-search
# bind -M normal \cn down-or-search
# bind -M insert \cp up-or-search
# bind -M insert \cn down-or-search
#
# bind -M insert \cs search
# bind -M normal \cs search
#
# bind -M insert \cz undo
# bind -M insert \cZ redo
# bind -M normal \cz undo
# bind -M normal \cZ redo

# Export nvim as manpager
export MANPAGER='nvim -c "nmap <silent> q :q!<Cr>" +Man!' export PAGER='nvim -c "nmap <silent> q :q!<Cr>" -R'
# Export nvim as editor
export EDITOR='nvim'

# Edit File with Sudo
alias svim='sudoedit'

# Genga
alias gengar="pokeget --hide-name glalie | fastfetch --file-raw - -c ~/.config/fastfetch/gengar.jsonc"

# overwrite greeting
function fish_greeting
    gengar
end

# Keyboard
# cat /proc/bus/input/devices | rg --context 10 "Translated"
alias kboff="sudo echo 1 | sudo tee /sys/class/input/event4/device/inhibited"
alias kbon="sudo echo 0 | sudo tee /sys/class/input/event4/device/inhibited"

#### CachyOs Aliases

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Get fastest mirrors
alias mirror="sudo cachyos-rate-mirrors"

alias tarnow='tar -acf '
alias untar='tar -zxvf '

## Useful aliases
# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons=always --hyperlink' # preferred listing
alias la='eza -a  --color=always --group-directories-first --icons=always --hyperlink' # all files and dirs
alias ll='eza -l  --color=always --group-directories-first --icons=always --hyperlink' # long format
alias lt='eza -aT --color=always --group-directories-first --icons=always --hyperlink' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles

# Append common directories for executable files to $PATH
fish_add_path ~/.local/bin ~/.cargo/bin ~/Applications/depot_tools
