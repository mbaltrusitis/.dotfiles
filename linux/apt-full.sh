#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at: $PWD"
	echo "$PWD/$0"
	exit 1;
fi


# Some necessary UNIX tools
apt-get install --fix-broken --show-progress --assume-yes \
	autoconf \
	automake \
	asciinema \
	aspell aspell-en \
	bash-completion \
	borgbackup \
	borgmatic \
	build-essential \
	clang \
	cmake \
	dbus \
	docker-compose-plugin \
	docker.io \
	editorconfig \
	emacs \
	exfat-fuse \
	exfat-utils \
	fail2ban \
	ffmpeg \
	fswatch \
	gnome-tweak-tool \
	gpg \
	jq \
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
	lua5.4 \
	lxd \
	magic-wormhole \
	mosh \
	mycli \
	netcat-openbsd \
	openssh-client \
	openssh-server \
	openvpn \
	pandoc \
	pgcli \
	postgresql \
	protobuf-compiler \
	shellcheck \
	stow \
	synapse \
	tk-dev \
	tig \
	tree \
	vim \
	virtualbox \
	wget \
	wireguard \
	wireshark \
	wuzz \
	xz-utils \
	youtube-dl \
	zfsutils-linux \
	zlib1g-dev;
