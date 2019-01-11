#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at: $PWD"
	echo "$PWD/$0"
	exit 1;
fi

# Some necessary Unix tools
apt-get install --fix-broken --show-progress --assume-yes \
	autoconf \
	automake \
	asciinema \
	aspell aspell-en \
	bash-completion \
	build-essential \
	cargo \
	clang \
	cmake \
	dbus \
	direnv \
	docker-compose \
	docker.io \
	duplicity \
	editorconfig \
	emacs \
	erlang \
	fail2ban \
	ffmpeg \
	flatpak \
	ghc \
	gnome-software-plugin-flatpak \
	golang \
	gpg \
	haskell-stack \
	htop \
	iftop \
	jq \
	kazam \
	libbz2-dev \
	libffi-dev \
	libncurses5-dev \
	libreadline-dev \
	libsqlite3-dev \
	libssl-dev \
	libtool \
	libxml2-dev \
	libxmlsec1-dev \
	llvm \
	lua5.1 \
	lxd \
	magic-wormhole \
	mosh \
	mycli \
	netcat-openbsd \
	nginx \
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
	tk-dev \
	tree \
	vim \
	virtualbox \
	wget \
	wireshark \
	xclip \
	xz-utils \
	youtube-dl \
	zeal \
	zfsutils-linux \
	zlib1g-dev;
