## Useful aliases
# Replace ls with lsd
alias ls='lsd -al --color=always --group-directories-first --icons=always --hyperlink' # preferred listing
alias la='lsd -a  --color=always --group-directories-first --icons=always --hyperlink' # all files and dirs
alias ll='lsd -l  --color=always --group-directories-first --icons=always --hyperlink' # long format
alias lt='lsd -aT --color=always --group-directories-first --icons=always --hyperlink' # tree listing
alias l.="lsd -a | grep -e '^\.'" # show only dotfiles
