#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at:"
	echo "$PWD/$0"
	exit 1;
fi

# the simple bare necessities
pacman -Syyu --noconfirm \
	curl \
	git \
	tmux;
