# git alias shortcuts
alias ga='git add -p'
alias gaa='git add '
alias gb='git b'
alias gc='git commit'
alias gd='git diff'
alias gg='git g'
alias glg='git log --all --decorate --graph --oneline'
alias go='git checkout'
alias grb='git rb'
alias gs='git status'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# tmux
alias tcopy='tmux loadb -'

# docker
alias dls='docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"'

alias cdlast='cd !$'
