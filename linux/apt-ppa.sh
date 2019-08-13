#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at: $PWD"
	echo "$PWD/$0"
	exit 1;
fi


# add PPAs
sudo apt-add-repository ppa:eosrei/fonts

# update index
sudo apt-get update

# install
sudo apt-get install fonts-twemoji-svginot
