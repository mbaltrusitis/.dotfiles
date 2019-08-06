#!/bin/bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	if test -r ~/.dircolors; then
		eval "$(dircolors -b ~/.dircolors)";
	else
		eval "$(dircolors -b)";
	fi
	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
	fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -f ~/.bash_aliases ]; then
	source ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		source /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion
	elif [ -f /usr/local/etc/bash_completion ]; then
		source /usr/local/etc/bash_completion
	fi
fi

# my edits start

# super user bin start
export PATH="/usr/local/sbin:$PATH"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi

# set PATH to include cargo-built binaries
if [ -d "$HOME/.cargo/bin" ] ; then
	PATH="$HOME/.cargo/bin:$PATH"
fi

# some FUNctions
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# mail
export MAILCHECK=60
export MAILPATH="/var/spool/mail/$USER"

# run ssh-agen start
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	ssh-agent > ~/.ssh-agent-proc
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
	eval "$(<~/.ssh-agent-proc)" 1> /dev/null
fi
# run ssh-agen end

# run gpg-agent start
gpg-agent --daemon 2> /dev/null
export GPG_TTY="$(tty)"
# run gpg-agent end

# private tokens start
if [ -f "$HOME/.tokens" ]; then
	source "$HOME/.tokens";
fi
# private tokens end

# aws profile start
if [ -z "$AWS_DEFAULT_PROFILE" ]; then
	export AWS_DEFAULT_PROFILE="notmatthew"
fi
# aws profile end

# kube configs start
if [ -d "$HOME/.kube" ]; then
	KUBECONFIG="";
	# append config-y files to the KUBECONFIG path
	for configFile in $HOME/.kube/*config; do
		export KUBECONFIG="$configFile:$KUBECONFIG";
	done
fi
# kube configs end

# my editor
export EDITOR="/usr/bin/vim"

# base16 shell start
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
	eval "$("$BASE16_SHELL/profile_helper.sh")"
	# base16-shell end

# direnv start
if hash direnv 2>/dev/null; then
	shell_env="$(echo "$SHELL" | rev | cut -d'/' -f1 | rev)"
	eval "$(direnv hook "$shell_env")"
	unset shell_env
fi
# direnv end

# scalaenv start
if [ -d "$HOME/.sbtenv/bin" ]; then
	export PATH="$HOME/.sbtenv/bin:$PATH";
	eval "$(sbtenv init -)"
fi
# scalaenv end

# scalaenv start
if [ -d "$HOME/.scalaenv/bin" ]; then
	export PATH="$HOME/.scalaenv/bin:$PATH";
	eval "$(scalaenv init -)"
fi
# scalaenv end

# pyenv start
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if hash pyenv 2>/dev/null; then
	eval "$(pyenv init -)"
fi
# pyenv end

# nodenv start
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
# noodenv end

# nvm start
export NVM_DIR="$HOME/.nvm"
if [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
	source "/usr/local/opt/nvm/nvm.sh";
fi

if [ -s "/usr/local/opt/nvm/etc/bash_completion" ]; then
	source "/usr/local/opt/nvm/etc/bash_completion";
fi
# nvm end

# npm start
export NPM_PACKAGES="$HOME/.npm-global"
export PATH="$NPM_PACKAGES/bin:$PATH"
unset -v MANPATH
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
# npm end

# erlang start
if [ -d "/usr/local/opt/erlang/lib/erlang/man" ]; then
	export MANPATH="/usr/local/opt/erlang/lib/erlang/man:$MANPATH"
fi
# erlang end

# virtualenvwrapper start
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
export VIRTUALENVWRAPPER_PYTHON=python3
if [ -f "$HOME/.local/bin/virtualenvwrapper.sh" ]; then
	# Linux
	source "$HOME/.local/bin/virtualenvwrapper.sh";
elif [ -f "$HOME/Library/Python/3.7/bin/virtualenvwrapper.sh" ]; then
	# Darwin
	source "$HOME/Library/Python/3.7/bin/virtualenvwrapper.sh";
	export PATH="$HOME/Library/Python/3.7/bin:$PATH"
else
	echo "W: Coudn't find virtualenvwrapper.sh"
fi
# virtualenvwrapper end

# poetry start
if [ -d "$HOME/.poetry/bin" ]; then
	export PATH="$HOME/.poetry/bin:$PATH"
fi
# poetry end

# OPAM start
if [ -f "$HOME/.opam/opam-init/init.sh" ]; then
	if source "$HOME/.opam/opam-init/init.sh" > /dev/null 2> /dev/null; then
		:  # pass // no-op
	else
		true;
	fi
else
	echo "W: OPAM seems not to be configured // installed.";
fi
# OPAM end

# scalaenv start
if hash scalaenv 2>/dev/null; then
	eval "$(scalaenv init -)"
fi
# scalaenv end

#kubectx // kubens start
if [ -d "$HOME/.kubectx" ]; then
	export PATH="$HOME/.kubectx:$PATH"
fi
#kubectx // kubens end

# bash completion start
if [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
	source "/usr/local/etc/profile.d/bash_completion.sh"
fi
# bash completion end

# flatpak start
if [ -d "/var/lib/flatpak/exports/share" ]; then
	export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
fi
# flatpak end

# visuals start
# PS1 nonsense
PS1="\[\e[37m\]"
PS1+="╭╴"
PS1+="\[\e[m\]"
PS1+="\[\e[31m\]"
PS1+="\u"
PS1+="\[\e[m\]"
PS1+="\[\e[37m\]"
PS1+="@"
PS1+="\[\e[m\]"
PS1+="\[\e[31m\]"
PS1+="\h"
PS1+="\[\e[m\]"
PS1+="\[\e[37m\]"
PS1+=" : "
PS1+="\[\e[m\]"
PS1+="\[\e[36m\]"
PS1+="\w"
PS1+="\n"
PS1+="\[\e[31m\]"
PS1+="\[\e[37m\]"
PS1+="╰╴"
PS1+="\[\e[m\]"
PS1+="\[\e[31m\]"
PS1+="🔥 "
PS1+="\[\e[m\]"

export CLICOLOR=1
export LS_COLORS='di=1;36:fi=0:ln=34:pi=5:so=33:bd=5:cd=5:or=37:mi=37:ex=32:*.rpm=1;31:*.zip=1;31'
# visuals end

export WINIT_HIDPI_FACTOR="1.6"

# my edits end
