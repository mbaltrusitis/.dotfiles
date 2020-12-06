#!/bin/bash

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=20000

# check the window size after each command and update the values of LINES and COLUMNS.
shopt -s checkwinsize

# "**" matches all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# colorize terminal start
if [[ -x /usr/bin/dircolors ]]; then
	eval "$(dircolors -b)";
fi
export TERM="screen-256color"
color_prompt=yes
export CLICOLOR=1
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# colorize terminal final

export WINIT_HIDPI_FACTOR="1.4"

# Default programs
export EDITOR="vim"
export TERMINAL="alacritty"
export BROWSER="firefox"
# export READER="zathura"

if [[ -f "$HOME/.bash_aliases" ]]; then
	source ~/.bash_aliases
fi

# Keep $HOME clean start
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
# Keep $HOME clean final
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.

export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export LESSHISTFILE="-"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"

# .local start
if [ -d "$HOME/.local/share/man" ]; then
	export MANPATH="$MANPATH:$HOME/.local/share/man"
fi

# .local start
if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi
# .local final

# super user bin start
export PATH="/usr/local/sbin:$PATH"


# rust start
if [ -d "$HOME/.cargo/bin" ] ; then
	PATH="$HOME/.cargo/bin:$PATH"
fi
# rust final

# go-lang start
#export GOPATH="$HOME/go"
#if [ -d "$GOPATH/bin" ]; then
	#export PATH="$GOPATH/bin:$PATH"
#fi
# go-lang final

# some FUNctions
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# mail
export MAILCHECK=60
export MAILPATH="/var/spool/mail/$USER"

# ssh-agent start
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	ssh-agent > ~/.ssh-agent-proc
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
	eval "$(<~/.ssh-agent-proc)" 1> /dev/null
fi
# ssh-agent final

# gpg-agent start
gpg-agent --daemon 2> /dev/null
export GPG_TTY="$(tty)"
# gpg-agent final

# private tokens start
if [ -f "$HOME/.tokens" ]; then
	source "$HOME/.tokens";
fi
# private tokens final

# aws profile start
if [ -z "$AWS_DEFAULT_PROFILE" ]; then
	export AWS_DEFAULT_PROFILE="notmatthew"
fi
# aws profile final

# kube configs start
if [ -d "$HOME/.kube" ]; then
	KUBECONFIG="";
	# append config-y files to the KUBECONFIG path
	for configFile in $HOME/.kube/*config.yaml; do
		export KUBECONFIG="$configFile:$KUBECONFIG";
	done
fi
# kube configs final

# base16 shell start
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
	eval "$("$BASE16_SHELL/profile_helper.sh")"
# base16-shell final

# direnv start
if hash direnv 2>/dev/null; then
	shell_env="$(echo "$SHELL" | rev | cut -d'/' -f1 | rev)"
	eval "$(direnv hook "$shell_env")"
	unset shell_env
fi
# direnv final

# asdf start
if [ -f "$HOME/.asdf/asdf.sh" ]; then
	source $HOME/.asdf/asdf.sh
fi
if [ -f "$HOME/.asdf/completions/asdf.bash" ]; then
	source $HOME/.asdf/completions/asdf.bash
fi
# asdf final

# npm start
export NPM_PACKAGES="$HOME/.npm-global"
export PATH="$NPM_PACKAGES/bin:$PATH"
unset -v MANPATH
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
# npm final

# erlang start
if [ -d "/usr/local/opt/erlang/lib/erlang/man" ]; then
	export MANPATH="/usr/local/opt/erlang/lib/erlang/man:$MANPATH"
fi
# erlang final

# virtualenvwrapper start
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
if [ -f "/usr/share/virtualenvwrapper/virtualenvwrapper.sh" ]; then
	# Linux
	export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
	source "/usr/share/virtualenvwrapper/virtualenvwrapper.sh";
elif [ -f "$HOME/Library/Python/3.7/bin/virtualenvwrapper.sh" ]; then
	# Darwin
	export VIRTUALENVWRAPPER_PYTHON=python3
	export PATH="$HOME/Library/Python/3.7/bin:$PATH"
	source "$HOME/Library/Python/3.7/bin/virtualenvwrapper.sh";
else
	:
fi
# virtualenvwrapper final

# poetry start
if [ -d "$HOME/.poetry/bin" ]; then
	export PATH="$HOME/.poetry/bin:$PATH"
fi
# poetry final

#kubectx // kubens start
if [ -d "$HOME/.kubectx" ]; then
	export PATH="$HOME/.kubectx:$PATH"
fi
#kubectx // kubens final

# bash completion start
if [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
	source "/usr/local/etc/profile.d/bash_completion.sh"
fi
# bash completion final

# flatpak start
if [ -d "/var/lib/flatpak/exports/share" ]; then
	export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
fi
# flatpak final

# z.sh start
if [ -f "/usr/local/lib/z/z.sh" ]; then
	source "/usr/local/lib/z/z.sh";
fi
# z.sh final

# nix start
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
	source "$HOME/.nix-profile/etc/profile.d/nix.sh;"
fi
# nix final

# java start
if [ -f "/usr/lib/jvm/java-11-openjdk-amd64/bin/java" ]; then
	export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
fi
# java final

# spark start
if [ -d "/opt/spark" ]; then
	export SPARK_HOME="/opt/spark"
	export PATH="$SPARK_HOME/bin:$PATH"
fi
# spark fine

# kafka start
if [ -d "/opt/kafka" ]; then
	export kafka_HOME="/opt/kafka"
	export PATH="$kafka_HOME/bin:$PATH"
fi
# kafka final

# fzf start
if hash fzf 2>/dev/null; then
	export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

	if [ -f "/usr/share/doc/fzf/examples/completion.bash" ]; then
		source /usr/share/doc/fzf/examples/completion.bash
	fi

	if [ -f "/usr/share/doc/fzf/examples/key-bindings.bash" ]; then
		source /usr/share/doc/fzf/examples/key-bindings.bash
	fi
fi
# fzf final

# visuals start
# PS1 nonsense
#PS1="\[\e[37m\]"
#PS1+="╭╴"
#PS1+="\[\e[m\]"
#PS1+="\[\e[31m\]"
#PS1+="\u"
#PS1+="\[\e[m\]"
#PS1+="\[\e[37m\]"
#PS1+="@"
#PS1+="\[\e[m\]"
#PS1+="\[\e[31m\]"
#PS1+="\h"
#PS1+="\[\e[m\]"
#PS1+="\[\e[37m\]"
#PS1+=" :: "
#PS1+="\[\e[m\]"
#PS1+="\[\e[36m\]"
#PS1+="\w"
#PS1+="\n"
#PS1+="\[\e[31m\]"
#PS1+="\[\e[37m\]"
#PS1+="╰╴"
#PS1+="\[\e[m\]"
#PS1+="\[\e[31m\]"
#PS1+="\[\e[m\]"
#PS1+="\[\e[31m\]"
#PS1+="🔥 "
## PS1+="🦃 "  # gobble gobble
## PS1+="🎄 "  # happy holidays
## PS1+="❄️ "   # brrr
#PS1+="\[\e[m\]"
#PS1+="\[\e[36m\]"
#PS1+="\[\e[m\]"

PS1="\[\e[32m\]"
# PS1+=" λ "
PS1+=" 🦃 "  # gobble gobble
# PS1+="🎄 "  # happy holidays
# PS1+="❄️ "   # brrr
PS1+="\[\e[m\]"
# visuals final
