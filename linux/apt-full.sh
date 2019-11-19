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
	bat \
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
	exfat-fuse \
	exfat-utils \
	fail2ban \
	ffmpeg \
	flatpak \
	ghc \
	gnome-software-plugin-flatpak \
	gnome-tweak-tool \
	golang-go \
	gpg \
	haskell-stack \
	hexyl \
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
	mono-devel \
	mosh \
	mycli \
	netcat-openbsd \
	nginx \
	ocaml \
	opam \
	openjdk-8-jre \
	openssh-client \
	openssh-server \
	openvpn \
	pandoc \
	pgcli \
	postgresql \
	protobuf-compiler \
	python3 \
	python3-pip \
	shellcheck \
	stow \
	synapse \
	tk-dev \
	thermald \
	tig \
	tlp \
	tlp-rdw \
	tree \
	vim \
	virtualbox \
	wget \
	wireshark \
	wuzz \
	xclip \
	xz-utils \
	youtube-dl \
	zeal \
	zfsutils-linux \
	zlib1g-dev;
