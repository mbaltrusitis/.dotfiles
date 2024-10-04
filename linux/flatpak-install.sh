#!/usr/bin/env bash

source ../utils/bash-utils.bash

if [[ $EUID -ne 0 ]]; then
	echo "[ERROR]: Executable $0 must run as ROOT! But you should inspect it first at: $PWD"
	echo "$PWD/$0"
	exit 1;
fi

readonly PACKAGE_LIST=(
	"com.discordapp.Discord"
	"com.github.wwmm.easyeffects"
	# "com.slack.Slack"
	"io.github.zen_browser.zen"
	"org.darktable.Darktable"
	"org.gimp.GIMP"
	"org.gimp.GIMP.manual"
)

function install_flatpak {
	if hash flatpak 2>/dev/null; then
		LOG_WARN "Flatpak is already installed. Skipping flatpak package install."
	else
		LOG_INFO "Installing flatpak package"
		sudo apt-get install flatpak;
	fi
}

configure_flatpak_repos ()
{
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install_packages() {
	for pkg in "${PACKAGE_LIST[@]}"; do
		flatpak install --noninteractive "$pkg"
	done
}

main() {
	install_flatpak;
	configure_flatpak_repos;
	install_packages;
}

main;
