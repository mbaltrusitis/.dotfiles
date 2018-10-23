#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at: $PWD"
	echo "$PWD/$0"
	exit 1;
fi

# Some necessary Unix tools
apt-get install --show-progress --assume-yes \
	aspell aspell-en \
	bash-completion \
	cargo \
	clang \
	cmake \
	dbus \
	direnv \
	duplicity \
	docker-compose \
	docker.io \
	emacs \
	erlang \
	fail2ban \
	ffmpeg \
	flatpak \
	ghc \
	golang \
	gpg \
	gnome-software-plugin-flatpak \
	haskell-stack \
	htop \
	iftop \
	jq \
	keepassxc \
	lua5.1 \
	lxd \
	magic-wormhole \
	mosh \
	mycli \
	netcat-openbsd \
	nginx \
	nodejs \
	npm \
	ocaml \
	openssh-client \
	openssh-server \
	pandoc \
	pgcli \
	postgresql \
	python3 \
	python3-pip \
	rust-doc \
	rust-src \
	rustc \
	shellcheck \
	stow \
	tree \
	vim \
	virtualbox \
	wireshark \
	xclip \
	youtube-dl \
	zeal;
