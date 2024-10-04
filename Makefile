.PHONY: all apt backup-bash dev-tools git-init help install link linux profile-source snap stow \
	unlink
.ONESHELL:

SHELL := /bin/bash
.SHELLFLAGS := -e -c

DOTFILE_DIR	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
# make utility functions available to all goals
export BASH_ENV := ./utils/bash-utils.bash

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

font-cache:
	$(info Resetting system font-cache)
	fc-cache -f

git-init:
	git submodule update --init --recursive

dev-tools: asdf

asdf:
	$(MAKE) -f ./Makefile.asdf
.PHONY: asdf

flatpak:
	sudo ./linux/flatpak-install.sh
.PHONY: flatpak

# veracrypt start
VERACRYPT_VERSION := 1.26.14
veracrypt: /usr/bin/veracrypt

/usr/bin/veracrypt:
	import_pgp_key_by_url "https://www.idrix.fr/VeraCrypt/VeraCrypt_PGP_public_key.asc"
	# download the package's signature
	curl -sSLo /tmp/veracrypt.deb.sig \
		'https://launchpad.net/veracrypt/trunk/$(VERACRYPT_VERSION)/+download/veracrypt-console-$(VERACRYPT_VERSION)-Ubuntu-22.04-amd64.deb.sig'
	# download the package itself
	curl -sSLo /tmp/veracrypt.deb \
		'https://launchpad.net/veracrypt/trunk/$(VERACRYPT_VERSION)/+download/veracrypt-console-$(VERACRYPT_VERSION)-Ubuntu-22.04-amd64.deb'
	# verify the downloaded package
	gpg --verify /tmp/veracrypt.deb.sig /tmp/veracrypt.deb
	# install the package
	sudo dpkg -i /tmp/veracrypt.deb
# veracrypt final

$(HOME)/enc-vol: veracrypt
	mkdir -p $(HOME)/enc-vol

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
	pushd ./_build && tar -xzf nvim-linux64.tar.gz

validate-nvim-download: fetch-nvim
	pushd ./_build && sha256sum -c nvim-linux64.tar.gz.sha256sum || exit 1
.PHONY: validate-nvim-download

fetch-nvim: _build/nvim-linux64.tar.gz.sha256sum _build/nvim-linux.tar.gz
.PHONY: fetch-nvim

_build/nvim-linux64.tar.gz.sha256sum: _build
	curl -sLo _build/nvim-linux64.tar.gz.sha256sum \
		'https://github.com/neovim/neovim/releases/download/v$(NVIM_VERSION)/nvim-linux64.tar.gz.sha256sum'

_build/nvim-linux.tar.gz: _build
	curl -sLo _build/nvim-linux64.tar.gz \
		'https://github.com/neovim/neovim/releases/download/v$(NVIM_VERSION)/nvim-linux64.tar.gz'
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
	curl -sL -o /tmp/hexyl.deb \
		"https://github.com/sharkdp/hexyl/releases/download/$(HEXYL_VERSION)/hexyl_$(HEXYL_VERSION:v%=%)_amd64.deb"
	sudo dpkg -i /tmp/hexyl.deb

BAT_VERSION := $(shell curl -s -w '%{redirect_url}\n' 'https://github.com/sharkdp/bat/releases/latest' | cut -d'/' -f8)
bat: /usr/bin/bat

/usr/bin/bat:
	curl -Ls -o /tmp/bat.deb \
		"https://github.com/sharkdp/bat/releases/download/$(BAT_VERSION)/bat_$(BAT_VERSION:v%=%)_amd64.deb"
	sudo dpkg -i /tmp/bat.deb

Z_VERSION := v1.12
z: /usr/local/src/z

/usr/local/src/z:
	sudo git clone https://github.com/rupa/z.git --branch $(Z_VERSION) /usr/local/src/z 2> /dev/null
	sudo ln -s /usr/local/src/z/z.sh /usr/local/bin/z

DIRENV_VERSION := 2.34.0
direnv: /usr/local/bin/direnv
.PHONY: direnv

/usr/local/bin/direnv:
	download_github_release_artifact "/tmp/direnv" \
		"https://github.com/direnv/direnv" \
		"direnv.linux-amd64" \
		"2.34.0"
	sudo chmod +x /tmp/direnv
	sudo mv /tmp/direnv /usr/local/bin/direnv

# KUBECTX_VERSION := 0.9.5
# kubectx: /usr/local/bin/kubectx
#
# /usr/local/bin/kubectx:
# 	download_github_release_artifact "/tmp/kubectx.tar.gz" \
# 		"https://github.com/ahmetb/kubectx" \
# 		"kubectx_v$(KUBECTX_VERSION)_linux_x86_64.tar.gz" \
# 		$(KUBECTX_VERSION)
# 	tar -xvzf /tmp/kubectx.tar.gz
# 	sudo mv /tmp/kubectx /usr/local/bin/kubectx

K9S_VERSION := 0.32.5
k9s: /usr/bin/k9s

/usr/bin/k9s:
	download_github_release_artifact "/tmp/k9s.deb" \
		"https://github.com/derailed/k9s" \
		"k9s_linux_amd64.deb" \
		$(K9S_VERSION)
	sudo dpkg -i "/tmp/k9s.deb"

FLYCTL_VERSION := 0.2.109
FLYCTL_INSTALL_PREFIX := $(HOME)/.fly
FLYCTL_INSTALL_SCRIPT_URL := https://fly.io/install.sh
FLYCTL_DOWNLOAD_DIR := /tmp/flyctl
flyctl: $(FLYCTL_INSTALL_PREFIX)

$(FLYCTL_INSTALL_PREFIX):
	mkdir -p $(FLYCTL_DOWNLOAD_DIR)
	curl -sSLo $(FLYCTL_DOWNLOAD_DIR)/install.sh $(FLYCTL_INSTALL_SCRIPT_URL)
	chmod +x $(FLYCTL_DOWNLOAD_DIR)/install.sh
	FLYCTL_INSTALL=$(FLYCTL_INSTALL_PREFIX) $(FLYCTL_DOWNLOAD_DIR)/install.sh
	rm -fr $(FLYCTL_DOWNLOAD_DIR)

AWS_PGP_KEY_PATH := ./data/aws.key
AWS_DOWNLOAD_DIR := /tmp/aws-cli
AWS_DOWNLOAD_PATH := $(AWS_DOWNLOAD_DIR)/aws.zip
aws-cli: /usr/local/bin/aws

/usr/local/bin/aws:
	mkdir -p $(AWS_DOWNLOAD_DIR)
	curl -sSLo $(AWS_DOWNLOAD_PATH) \
		"https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.18.0.zip"
	curl -sSLo $(AWS_DOWNLOAD_DIR)/awscliv2.sig \
		"https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.18.0.zip.sig"
	import_pgp_key_by_file $(AWS_PGP_KEY_PATH)
	gpg --verify $(AWS_DOWNLOAD_DIR)/awscliv2.sig $(AWS_DOWNLOAD_PATH)
	unzip -d $(AWS_DOWNLOAD_DIR) $(AWS_DOWNLOAD_PATH)
	@sudo $(AWS_DOWNLOAD_DIR)/aws/install
	rm -fr $(AWS_DOWNLOAD_DIR)
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
