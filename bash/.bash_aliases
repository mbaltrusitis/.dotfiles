# neovim
if hash nvim 2>/dev/null; then
	alias vim='nvim'
fi

# git alias shortcuts
alias ga='git add -p'
alias gaa='git add '
alias gb='git b'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gg='git g'
alias glg='git log --all --decorate --graph --oneline'
alias grb='git rb'
alias gs='git status'

# allows you to "go back" via popd
# alias cd='pushd'

# some more ls aliases
alias ls="ls --color=auto"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=normal -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# tmux
alias tcopy='tmux loadb -'

# docker
alias d='docker'
alias dls='docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"'

# kube
alias k='kubectl'
alias mk='microk8s.kubectl'
alias kubectx="kubectl config use-context"

# wireguard
alias wgup='wg-quick up us-ny1'
alias wgdn='wg-quick down us-ny1'

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias borg1='borg'

alias tls='tmux ls'
alias tns='ts'
