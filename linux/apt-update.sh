#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at:"
	echo "$PWD/$0"
	exit 1;
fi

# update and upgrade
apt-get update
apt-get upgrade --assume-yes
apt-get dist-upgrade -f
