#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at: $PWD"
	echo "$PWD/$0"
	exit 1;
fi

PPA_INSTALLS=""

function add_package {
	PPA_INSTALLS+="$1 "
}

echo "I: Adding GPG keys"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64

echo "I: Adding PPA repos"
# veracrypt
add-apt-repository --yes ppa:unit193/encryption
add_package "veracrypt"
# yq
sudo add-apt-repository --yes ppa:rmescandon/yq
add_package "yq"

echo "I: Installing the list of packages below:"
echo ""I: "${PPA_INSTALLS}"""
apt-get install --show-progress --assume-yes $PPA_INSTALLS
