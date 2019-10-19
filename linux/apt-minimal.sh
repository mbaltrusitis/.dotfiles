#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at:"
	echo "$PWD/$0"
	exit 1;
fi

# the simple bare necessities
apt-get install --show-progress --assume-yes \
	curl \
	dmsetup \
	git \
	libfuse2 \
	tmux;
