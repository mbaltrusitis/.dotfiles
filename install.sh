#!/bin/bash

set -u

setup() {
	if [ -z "$(which curl)" ]; then
		echo "Installing necessary tooling..."
		apt-get install curl
	fi
}

fetch_dots() {
	echo "Fetching zipped repo and unzipping..."
	curl -Lo /tmp/dotfiles.zip https://github.com/mbaltrusitis/.dotfiles/archive/master.zip
	unzip /tmp/dotfiles.zip -d /tmp/dotfiles
}

main() {
	setup
	fetch_dots
}

main
