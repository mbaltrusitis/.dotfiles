# enable autocompletion
autoload -U compinit; compinit

# enable color escapes
autoload -U colors; colors

# base16
BASE16_SHELL="$HOME/.config/base16-shell/"
if [ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ]; then
		eval "$("$BASE16_SHELL/profile_helper.sh")"
fi

if [[ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]]; then
	source "/opt/homebrew/opt/asdf/libexec/asdf.sh"
fi

# Load shortcuts
if [[ -f "$HOME/.bash_aliases" ]]; then
	source "$HOME/.bash_aliases"
fi

if [ "$(uname)" = "Darwin" ]; then
	alias veracrypt="/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text"
fi

export PS1="%{$fg[magenta]%}ƛ%{$reset_color%} "
