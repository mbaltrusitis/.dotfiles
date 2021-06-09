#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ "$(id -u)" != 0 ]; then
	printf "E: Executable %s must run as ROOT!\\n" "$0"
	exit 1;
fi

getusertarget() {
	while true
	do
		read -rp "What user's environment should be targeted? " username
		if [ -n "$(getent passwd "$username")" ]; then
			printf "I: Targeting username \"%s\".\\n" "$username"
			break;
		else
			printf "\nE: User does not exist.\\n"
		fi
	done
}

installpkg(){ pacman --noconfirm --needed -S "$1" #>/dev/null 2>&1 ;
}

refreshkeys() {
	pacman --noconfirm -S gnupg archlinux-keyring manjaro-keyring #>/dev/null 2>&1
}

newperms() {  # Set special sudoers settings for install (or after).
	sed -i "/#NM/d" /etc/sudoers
	echo "$* #NM" >> /etc/sudoers ;
}

maininstall() {  # Installs all needed programs from main repo.
	printf "Official: %s %s \\n" "$1" "${2-}"
	installpkg "$1"
}

aurinstall() {
	printf "AUR: %s %s \\n" "$1" "${2-}"
	su -c "$aurhelper -S --norebuild --noredownload --noconfirm $1" - "$username"
}

installationloop() {
	([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" | sed '/^#/d' > /tmp/progs.csv
	# remove CSV headers
	sed -i "/^tag,program,comment$/d" /tmp/progs.csv

	total=$(wc -l < /tmp/progs.csv)
	#aurinstalled=$(pacman -Qqm)
	installed_count=0

	while IFS=, read -r tag program comment; do
		installed_count=$((installed_count+1))
		# shellcheck disable=SC2001
		echo "$comment" | grep -q "^\".*\"$" && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
		case "$tag" in
			"AUR") aurinstall "$program" "$comment" ;;
			#"G") gitmakeinstall "$program" "$comment" ;;
			#"P") pipinstall "$program" "$comment" ;;
			*) maininstall "$program" "$comment" ;;
		esac
		echo "Installed $installed_count of $total"
	done < /tmp/progs.csv ;
}

createFullProgramsFile() {
	rm "$progsfile"
	for fileName in "${programsFileList[@]}"; do
		cat "$fileName" >> "$progsfile"
	done
}

preinstallmsg() {  # last chance to abort!
	local programList=""

	for fileName in "${programsFileList[@]}"; do
		programList+="$fileName "
	done

	cat <<-HEREDOC
	This script will run with the following config:

		Target user:     $username
		Aurhelper:       $aurhelper
		Program File(s): $programList
		Dotfilesrepo:    $dotfilesrepo
		Repobranch:      $repobranch

HEREDOC

	while true
	do
		read -rp "Continue with setup? [Y/n] " isAccepted
		case "$isAccepted" in
			y|Y|yes|'')
				printf "Config accepted. Continuing.\n"
				;;
			*)
				printf "Config denied. Exiting.\n"
				exit 0
				;;
		esac
		break
	done
}

# Script Start

while getopts ":u:a:r:b:p:h" o; do
	case "${o}" in
		a)
			aurhelper=${OPTARG}
			;;
		p)
			programsFileList+=("${OPTARG}")
			;;
		r)
			dotfilesrepo=${OPTARG}
			if ! git ls-remote "$dotfilesrepo"; then exit 1; fi
			;;
		b)
			repobranch=${OPTARG}
			;;
		u)
			username=${OPTARG}
			;;
		h)
			printf "Optional arguments for custom use:\\n  -r: Dotfiles repository (local file or url)\\n  -p: Dependencies and programs csv (local file or url)\\n  -a: AUR helper (must have pacman-like syntax)\\n  -h: Show this message\\n" && exit 1
			;;
		*)
			printf "Invalid option: -%s\\n" "$OPTARG" && exit 1
			;;
	esac
done

# Set programs list to base CSV file if no -p flags were passed.
defaultProgramsList=("programs.csv")


# Check for unset options and provide defaults
if [[ -z "${dotfilesrepo+.}" ]]; then dotfilesrepo="https://github.com/mbaltrusitis/.dotfiles.git"; fi
if [[ -z "${programsFileList+.}" ]]; then programsFileList=("${programsFileList[@]:-${defaultProgramsList[@]}}"); fi
if [[ -z "${username+.}" ]]; then printf "-u is required to specify target user" && exit 1; fi
if [[ -z "${aurhelper+.}" ]]; then aurhelper="yay"; fi
if [[ -z "${repobranch+.}" ]]; then repobranch="master"; fi

# Last chance to exit after showing configured options.
preinstallmsg

progsfile="$(mktemp --tmpdir programs.XXXXXX)"
createFullProgramsFile

# getusertarget

refreshkeys

# Install basic packages needed for install steps.
for pkg in curl base-devel git ntp; do
	installpkg "$pkg"
done

# echo "XXX:new perms 1"
newperms "%wheel ALL=(ALL) NOPASSWD: ALL"

# echo "XXX:colorizing"
# Colorize and increase verbosity.
grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# echo "XXX:all cores"
# Use all cores for compilation.
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# echo "XXX:ensuring $aurhelper"
# Ensure $aurhelper is installed
if ! installpkg $aurhelper; then echo "Failed to install AUR helper."; fi

# echo "XXX:the main show"
# Main installation command.
installationloop

# patches libXft to provide color emoji
# aurinstall "libxft-bgra-git"
yes | su -c "$aurhelper -S --norebuild --noredownload libxft-bgra-git" - "$username"

# echo "XXX:ew perms 2"
newperms "%wheel ALL=(ALL) ALL #NM
%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/pacman -Syyuw --noconfirm"

