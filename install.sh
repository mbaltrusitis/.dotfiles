#!/bin/bash

set -u

setup() {
	INSTALL_LIST=""
	if [ -z "$(which curl)" ]; then
		INSTALL_LIST+="curl"
	fi

	if [ -z "$(which curl)" ]; then
		INSTALL_LIST=" unzip"
	fi

	if ! [ -z "$INSTALL_LIST" ]; then
		echo "I: Installing necessary tooling..."
		apt-get install --show-progress --assume-yes "$INSTALL_LIST"
	else
		echo "I: Requirements met."
	fi
	unset -v INSTALL_LIST
}

fetch_dots() {
	echo "I: Fetching zipped repo..."
	if curl -sLo /tmp/dotfiles.zip https://github.com/mbaltrusitis/.dotfiles/archive/master.zip; then
		echo "I: Unzipping..."
		unzip -qf /tmp/dotfiles.zip -d /tmp/dotfiles;
	else
		echo "E: Download failed."
	fi
	echo "I: Great success!"
}

main() {
	setup
	fetch_dots
}

main
echo "I: Done."
