#!/usr/bin/env bash

# logger helpers
LOG_DEBUG() { printf "\e[0;34m[DEBUG] %s\e[0m\n" "$1" ; }
LOG_INFO() { printf "\e[0;32m[INFO]  %s\e[0m\n" "$1" ; }
LOG_ERROR() { printf "\e[0;31m[ERROR] %s\e[0m\n" "$1" ; }
LOG_WARNING() { printf "\e[0;33m[WARN]  %s\e[0m\n" "$1" ; }

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
export color_prompt=yes
export CLICOLOR=1
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# colorize terminal final

export WINIT_HIDPI_FACTOR="1.4"

# Default programs
export EDITOR="vim"
export TERMINAL="kitty"
export BROWSER="firefox"

if [[ -f "$HOME/.bash_aliases" ]]; then
	source "$HOME/.bash_aliases"
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
export _Z_DATA="${XDG_DATA_HOME:-$HOME/}/.z"

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

# some FUNctions
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# mail
export MAILCHECK=60
export MAILPATH="/var/spool/mail/$USER"

# private tokens start
if [ -f "$HOME/.tokens" ]; then
	source "$HOME/.tokens";
fi
# private tokens final

# brew start
if [ "$(uname)" = "Darwin" ] && [ -d "/opt/homebrew/" ]; then
	export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
	if [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]]; then
		source "/opt/homebrew/etc/profile.d/bash_completion.sh"
	fi
fi
# brew final

# base16 shell start
BASE16_SHELL="$HOME/.config/base16-shell"
if [ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ]; then
    source "$BASE16_SHELL/profile_helper.sh"
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
if [ -f "$HOME/.asdf/asdf.sh" ]; then
	source "$HOME/.asdf/asdf.sh"
fi
if [ -f "$HOME/.asdf/completions/asdf.bash" ]; then
	source "$HOME/.asdf/completions/asdf.bash"
fi
# asdf final

# erlang start
if [ -d "/usr/local/opt/erlang/lib/erlang/man" ]; then
	export MANPATH="/usr/local/opt/erlang/lib/erlang/man:$MANPATH"
fi
# erlang final

# macOS python start
if [ -d "/Library/Frameworks/Python.framework/Versions/3.9/bin"  ]; then
    DEV_PYTHON_PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin"
    export PATH="$DEV_PYTHON_PATH:$PATH"
fi
# macOS python final

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
if [[ -f "/etc/bash_completion" ]]; then
	source "/etc/bash_completion"
fi
# bash completion final

# z.sh start
if [ -r "$HOME/.local/src/z/z.sh" ]; then
    source "$HOME/.local/src/z/z.sh";
fi
# z.sh final

# fzf start
if hash fzf 2>/dev/null; then
	export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

	if [ -f "/usr/share/doc/fzf/examples/completion.bash" ]; then
		source "/usr/share/doc/fzf/examples/completion.bash"
	fi

	if [ -f "/usr/share/doc/fzf/examples/key-bindings.bash" ]; then
		source "/usr/share/doc/fzf/examples/key-bindings.bash"
	fi
fi
# fzf final

__python_auto_activate_virtualenv() {
    # get the first (alphabetically) .venv-* directory
    typeset -r first_found_venv="$(find . -maxdepth 1 -type d -name '.venv-*' | sort | head -n 1)"
    # disable `activate` from editing PS1
    # shellcheck disable=SC2034
    VIRTUAL_ENV_DISABLE_PROMPT=1

    if [[ -n "$first_found_venv" ]] && [[ -r "$first_found_venv" ]]; then
        # a venv has been found, get its name and path
        typeset -r venv_name="$(basename "${first_found_venv}")"
        typeset -r venv_path="$(pwd -P)/${venv_name}"
        typeset -r venv_activate="${venv_path}/bin/activate"

        # deactivate a mismatched venv
        if [[ -n "$VIRTUAL_ENV" ]] && [[ "$VIRTUAL_ENV" != "$venv_path" ]]; then
            typeset -r old_venv_name="$(basename "$VIRTUAL_ENV")"

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
            if source "${venv_activate}"; then
                LOG_INFO "Activated venv ${venv_name}"
            else
                LOG_ERROR "Failed to activate venv ${venv_name}"
                return 1
            fi
        fi
    fi
}

# prompt formatting start
if [ -r "$HOME/.local/src/ps1_setup.sh" ]; then
    source "$HOME/.local/src/ps1_setup.sh"
fi
# prompt formatting final

export PROMPT_COMMAND="$PROMPT_COMMAND __python_auto_activate_virtualenv; __setup_ps1; "

