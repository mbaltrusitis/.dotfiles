# git alias shortcuts
alias ga='git add -p'
alias gaa='git add '
alias gb='git b'
alias gc='git commit'
alias gd='git diff'
alias gg='git g'
alias glg='git log --all --decorate --graph --oneline'
alias grb='git rb'
alias gs='git status'

# allows you to "go back" via popd
# alias cd='pushd'

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

# kube
alias k='kubectl'
alias mk='microk8s.kubectl'
alias kubectx="kubectl config use-context"

# common things
alias ssh-heat='sudo ssh -F ~/.ssh/config heat.nyc -i ~/.ssh/id_rsa'

# wireguard
alias wgup='wg-quick up us-ny1'
alias wgdn='wg-quick down us-ny1'
