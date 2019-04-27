# ~/.bash_profile: executed by the command interpreter for login shells.

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		source "$HOME/.bashrc"
	fi
fi

# opam configuration
test -r /Users/mbaltrusitis/.opam/opam-init/init.sh && . /Users/mbaltrusitis/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
