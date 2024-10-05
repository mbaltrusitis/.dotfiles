#!/usr/bin/env bash

# logger helpers
LOG_DEBUG() { printf "\e[0;34m[DEBUG] %s\e[0m\n" "$1" ; }
LOG_INFO() { printf "\e[0;32m[INFO]  %s\e[0m\n" "$1" ; }
LOG_ERROR() { printf "\e[0;31m[ERROR] %s\e[0m\n" "$1" ; }
LOG_WARNING() { printf "\e[0;33m[WARN]  %s\e[0m\n" "$1" ; }

# Description: Test a given $path and if true `source` it
# Note:
#   The valid values for the conditional (i.e., $1) can be found by running:
#   'man test'
test_and_source() {
	local conditional="$1"
	local path="$2"
	local partial="test $conditional $path"

	# shellcheck disable=SC1090
	if eval "$partial"; then
		source "$path"
	fi
}

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
export color_prompt=yes
export CLICOLOR=1
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# colorize terminal final

export WINIT_HIDPI_FACTOR="1.4"

# Default programs
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"

test_and_source "-f" "$HOME/.bash_aliases"

# Keep $HOME clean start
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
# Keep $HOME clean final

export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export LESSHISTFILE="-"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export _Z_DATA="${XDG_DATA_HOME:-$HOME/}/.z"
export CDPATH=".:..:$HOME/Projects:$HOME"

# elixir livebook start
export LIVEBOOK_PORT="9999"
export LIVEBOOK_PASSWORD="banana#phone1"
export LIVEBOOK_HOME="$HOME/Projects/Livebooks"
# elixir livebook final

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

# mail
export MAILCHECK=60
export MAILPATH="/var/spool/mail/$USER"

# private tokens start
test_and_source "-f" "$HOME/.tokens"
# private tokens final

# base16 shell start
BASE16_SHELL="$HOME/.config/base16-shell"
if [ -n "$PS1" ]; then
    test_and_source "-s" "$BASE16_SHELL/profile_helper.sh"
fi
# base16-shell final

# direnv start
if hash direnv 2>/dev/null; then
	shell_env="$(echo "$SHELL" | rev | cut -d'/' -f1 | rev)"
	eval "$(direnv hook "$shell_env")"
	unset shell_env
fi
# direnv final

# asdf start
test_and_source "-f" "$HOME/.asdf/asdf.sh"
test_and_source "-f" "$HOME/.asdf/completions/asdf.bash"
# asdf final

# erlang start
if [ -d "/usr/local/opt/erlang/lib/erlang/man" ]; then
	export MANPATH="/usr/local/opt/erlang/lib/erlang/man:$MANPATH"
fi
# erlang final

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

# z.sh start
test_and_source "-r" "$HOME/.local/src/z/z.sh"
# z.sh final

# fzf start
if hash fzf 2>/dev/null; then
	export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
	test_and_source "-f" "/usr/share/doc/fzf/examples/completion.bash"
	test_and_source "-f" "/usr/share/doc/fzf/examples/key-bindings.bash"
fi
# fzf final

# mason start
if [ -d "$HOME/.local/share/nvim/mason/bin" ]; then
    export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
fi
# mason final

# fly start
if [ -d "$HOME/.fly" ]; then
  export FLYCTL_INSTALL="/home/heatmiser/.fly"
fi

if [ -d "$HOME/.fly/bin" ]; then
  export PATH="$FLYCTL_INSTALL/bin:$PATH"
fi
# fly final

# aws cli start
if hash aws 2>/dev/null && [ -f '/usr/local/bin/aws_completer' ]; then
	complete -C '/usr/local/bin/aws_completer' aws
fi
# aws cli final

__python_auto_activate_virtualenv() {
    # get the first (alphabetically) .venv-* directory
    declare -r first_found_venv="$(find . -maxdepth 1 -type d -name '.venv-*' | sort | head -n 1)"
    # disable `activate` from editing PS1
    # shellcheck disable=SC2034
    VIRTUAL_ENV_DISABLE_PROMPT=1

    if [[ -n "$first_found_venv" ]] && [[ -r "$first_found_venv" ]]; then
        # a venv has been found, get its name and path
        declare -r venv_name="$(basename "${first_found_venv}")"
        declare -r venv_path="$(pwd -P)/${venv_name}"
        declare -r venv_activate="${venv_path}/bin/activate"

        # deactivate a mismatched venv
        if [[ -n "$VIRTUAL_ENV" ]] && [[ "$VIRTUAL_ENV" != "$venv_path" ]]; then
            declare -r old_venv_name="$(basename "$VIRTUAL_ENV")"

            # check for the `deactivate` function and call it
            if [[ "$(type -t deactivate)" = "function" ]] && deactivate; then
                LOG_INFO "Deactivated venv ${old_venv_name}"
            else
                LOG_ERROR "Failed to deactivate venv ${old_venv_name}"
                return 1
            fi
        fi

        # if a venv is not activated, activate the one we found
        if [[ -z "$VIRTUAL_ENV" ]] && [[ -r "$venv_activate" ]]; then
            # shellcheck disable=SC1090
            if test_and_source "-r" "$venv_activate"; then
                LOG_INFO "Activated venv ${venv_name}"
            else
                LOG_ERROR "Failed to activate venv ${venv_name}"
                return 1
            fi
        fi
    fi
}

# prompt formatting start
test_and_source "-r" "$HOME/.local/src/ps1_setup.sh"
# prompt formatting final

export PROMPT_COMMAND="$PROMPT_COMMAND __python_auto_activate_virtualenv; __setup_ps1; "
