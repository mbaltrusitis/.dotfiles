# enable autocompletion
autoload -U compinit; compinit

eval "$(/opt/homebrew/bin/brew shellenv)"

# base16
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
		eval "$("$BASE16_SHELL/profile_helper.sh")"

export PS1="ƛ "

if [[ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]]; then
	source "/opt/homebrew/opt/asdf/libexec/asdf.sh"
fi

alias ls="ls --color=auto"
alias ll="ls -asl"

# Elixir
export PLUG_EDITOR="vscode://file/__FILE__:__LINE__"
export TERMINAL="kitty"
export TERM="xterm-kitty"
export BROWSER="firefox"
export EDITOR="nvim"

# Load them shortcuts
if [[ -f "$HOME/.bash_aliases" ]]; then
  source "$HOME/.bash_aliases"
fi

# Keep $HOME clean
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export PS1="ƛ "
