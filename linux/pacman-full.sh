#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "E: Executable $0 must run as ROOT! But you should inspect it first at: $PWD"
	echo "$PWD/$0"
	exit 1;
fi


# Some necessary UNIX tools
pacman -Syyu --noconfirm --needed \
	asciinema \
	aspell \
	aspell-en \
	base-devel \
	bash-completion \
	bat \
	borg \
	borgmatic \
	clang \
	cmake \
	code \
	dbeaver \
	docker \
	docker-compose \
	emacs \
	erlang \
	fail2ban \
	ffmpeg \
	flatpak \
	fwupd \
	ghc \
	go \
	hexyl \
	iftop \
	jq \
	llvm \
	lua52 \
	lxd \
	mosh \
	nginx \
	npm \
	ocaml \
	opam \
	pandoc \
	postgresql \
	rustup \
	s-tui \
	shellcheck \
	signal-desktop \
	smartmontools \
	stack \
	stow \
	tlp \
	linux54-rt-acpi_call \
	tree \
	vim \
	virtualbox \
	wireshark-cli \
	wireshark-qt \
	xclip \
	youtube-dl \
	zeal;
