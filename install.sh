#!/bin/bash

set -u

setup() {
	INSTALL_LIST=""
	if [ -z "$(which curl)" ]; then
		INSTALL_LIST+="curl"
	fi

	if [ -z "$(which unzip)" ]; then
		INSTALL_LIST+=" unzip"
	fi

	if [ -n "$INSTALL_LIST" ]; then
		echo "[INFO]: Installing necessary tooling..."
		sudo apt-get install --show-progress --assume-yes "$INSTALL_LIST"
	else
		echo "[INFO]: Requirements met."
	fi
	unset -v INSTALL_LIST
}

fetch_dots() {
	DOWNLOAD_DIR=$(mktemp -d)
	echo "[INFO]: Downloading zipped repo to '$DOWNLOAD_DIR'"
	if curl --silent --show-error --location --output "$DOWNLOAD_DIR/dotfiles.zip" \
			"https://github.com/mbaltrusitis/.dotfiles/archive/master.zip"; then
		echo "[INFO]: Unzipping..."
		mkdir -p "$DOWNLOAD_DIR/out"
		unzip -q "$DOWNLOAD_DIR/dotfiles.zip" -d "$DOWNLOAD_DIR/out";
		[ -d /tmp/dotfiles ] && rm -rf /tmp/dotfiles
		mv --force "$DOWNLOAD_DIR/out/.dotfiles-master" /tmp/dotfiles
		rmdir "$DOWNLOAD_DIR/out"
	else
		echo "[ERROR]: Download failed."
		exit 1
	fi
	echo -e "[INFO]: Great success!\nFiles located at /tmp/dotfiles"
}

main() {
	setup
	fetch_dots
}

main
echo "[INFO]: Done."
