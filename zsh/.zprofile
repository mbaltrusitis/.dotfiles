eval "$(/opt/homebrew/bin/brew shellenv)"

# base16
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
		eval "$("$BASE16_SHELL/profile_helper.sh")"

# load zshrc
if [[ "$SHELL" == "/bin/zsh" ]]; then
    # include .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc"
    fi
fi

