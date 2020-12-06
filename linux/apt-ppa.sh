#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at: $PWD"
	echo "$PWD/$0"
	exit 1;
fi


# add PPAs
sudo add-apt-repository ppa:unit193/encryption

# update index
sudo apt-get update

# install
sudo apt install veracrypt
