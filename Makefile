.PHONY: all apt backup-bash dev-tools enc-vol git-init help install link linux profile-source snap \
	stow unlink
.ONESHELL:

SHELL := /bin/bash
DOTFILE_DIR	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')

all: install
install: $(OS)
linux: git-init stow dev-tools

packages: apt flatpak

apt:
	$(info You may be prompted for super-user privleges:)
	sudo linux/apt-update.sh
	sudo linux/apt-minimal.sh
	sudo linux/apt-full.sh
	sudo linux/apt-ppa.sh
	sudo linux/snap.sh

# TODO: Add Yubikey PAM


font-cache:
	$(info Resetting system font-cache)
	$(shell fc-cache -f)

git-init:
	git submodule update --init --recursive

dev-tools: asdf

asdf:
	$(MAKE) -f ./Makefile.asdf
.PHONY: asdf

flatpak:
	$(shell sudo ./linux/flatpak-install.sh)
.PHONY: flatpak

$(HOME)/enc-vol:
	mkdir -p $(HOME)/enc-vol

enc-vol: $(HOME)/enc-vol

mount-enc: $(HOME)/enc-vol
	veracrypt -t -k "" --pim=0 --protect-hidden=no enc/vol.vc $(HOME)/enc-vol

umount-enc:
	veracrypt -d $(HOME)/enc-vol

# nvim start
NVIM_VERSION := 0.10.0
nvim: link-nvim
.PHONY: nvim

link-nvim: _build/nvim-linux64
	sudo ln -sf $$PWD/_build/nvim-linux64/bin/* /usr/local/bin/
	sudo ln -sf $$PWD/_build/nvim-linux64/lib/* /usr/local/lib/
	sudo ln -sf $$PWD/_build/nvim-linux64/man/* /usr/local/man/
	sudo ln -sf $$PWD/_build/nvim-linux64/share/* /usr/local/share/
.PHONY: link-nvim

_build/nvim-linux64: validate-nvim-download
	pushd ./_build && tar -xzvf nvim-linux64.tar.gz

validate-nvim-download: fetch-nvim
	pushd ./_build && sha256sum -c nvim-linux64.tar.gz.sha256sum || exit 1
.PHONY: validate-nvim-download

fetch-nvim: _build/nvim-linux64.tar.gz.sha256sum _build/nvim-linux.tar.gz
.PHONY: fetch-nvim

_build/nvim-linux64.tar.gz.sha256sum: _build
	curl -sLo _build/nvim-linux64.tar.gz.sha256sum 'https://github.com/neovim/neovim/releases/download/v$(NVIM_VERSION)/nvim-linux64.tar.gz.sha256sum'

_build/nvim-linux.tar.gz: _build
	curl -sLo _build/nvim-linux64.tar.gz 'https://github.com/neovim/neovim/releases/download/v$(NVIM_VERSION)/nvim-linux64.tar.gz'
# nvim final

_build:
	mkdir -p ./_build

profile-source:
	source $(HOME)/.bash_profile

backup-bash:
	$(DOTFILE_DIR)/bash_backup.sh

## git installs start

HEXYL_VERSION := $(shell curl -s -w '%{redirect_url}\n' 'https://github.com/sharkdp/hexyl/releases/latest' | cut -d'/' -f8)
hexyl: /usr/bin/hexyl

/usr/bin/hexyl:
	curl -sL -o /tmp/hexyl.deb "https://github.com/sharkdp/hexyl/releases/download/$(HEXYL_VERSION)/hexyl_$(HEXYL_VERSION:v%=%)_amd64.deb";
	sudo dpkg -i /tmp/hexyl.deb;

BAT_VERSION := $(shell curl -s -w '%{redirect_url}\n' 'https://github.com/sharkdp/bat/releases/latest' | cut -d'/' -f8)
bat: /usr/bin/bat

/usr/bin/bat:
	curl -Ls -o /tmp/bat.deb "https://github.com/sharkdp/bat/releases/download/$(BAT_VERSION)/bat_$(BAT_VERSION:v%=%)_amd64.deb";
	sudo dpkg -i /tmp/bat.deb;

Z_VERSION := v1.12
z: /usr/local/src/z

/usr/local/src/z:
	sudo git clone https://github.com/rupa/z.git --branch $(Z_VERSION) /usr/local/src/z 2> /dev/null
	sudo ln -s /usr/local/src/z/z.sh /usr/local/bin/z
## git installs final

$(HOME)/.local/bin/op:
	gpg --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
	gpg --verify op.sig op
	curl -Ls -o op.

stow:
	stow bash
	stow bin
	stow config
	stow fonts
	stow ssh
	stow tmux

link: backup-bash
	ln -fs bash/.bash_aliases $(HOME)/.bash_aliases
	ln -fs bash/.bash_logout $(HOME)/.bash_logout
	ln -fs bash/.bash_profile $(HOME)/.bash_profile
	ln -fs bash/.bashrc $(HOME)/.bashrc
	ln -fs bash/.curlrc $(HOME)/.curlrc
	ln -fs bin/bin $(HOME)/bin

unlink:
	unlink $(HOME)/.bash_aliases
	unlink $(HOME)/.bash_logout
	unlink $(HOME)/.bash_profile
	unlink $(HOME)/.bashrc
	unlink $(HOME)/.curlrc

help:
	@echo "help yourself :P"
