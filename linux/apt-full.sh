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
	build-essential \
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
	fswatch \
	ghc \
	gnome-tweak-tool \
	golang-go \
	gpg \
	haskell-stack \
	htop \
	iftop \
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
	lua5.1 \
	lxd \
	magic-wormhole \
	mono-devel \
	mosh \
	mycli \
	neovim \
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
	python3-neovim \
	ruby \
	ruby-neovim \
	shellcheck \
	stow \
	synapse \
	tk-dev \
	thermald \
	tig \
	tree \
	vim \
	virtualbox \
	wget \
	wireguard \
	wireshark \
	wuzz \
	xclip \
	xz-utils \
	youtube-dl \
	zfsutils-linux \
	zlib1g-dev;
