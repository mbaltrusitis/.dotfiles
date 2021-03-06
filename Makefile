.PHONY: all apt backup-bash brew-sync darwin dev-tools enc-vol git-init help install link linux \
	profile-source snap stow unlink
.ONESHELL:

SHELL		= /bin/bash
DOTFILE_DIR	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OS			:= $(shell uname -s | tr '[:upper:]' '[:lower:]')


all: install
install: $(OS)
linux: git-init stow dev-tools profile-source font-cache
darwin: brew brew-upgrade git-init stow profile-source


apt:
	$(info You may be prompted for super-user privleges:)
	sudo linux/apt-update.sh
	sudo linux/apt-minimal.sh
	sudo linux/apt-full.sh
	sudo linux/apt-ppa.sh
	sudo linux/snap.sh

pacman:
	$(info You may be prompted for super-user privleges:)
	sudo linux/pacman-full.sh
	linux/pamac.sh

# TODO: Add Yubikey PAM

darwin: brew
	sudo softwareupdate -aiR

brew: /usr/local/Homebrew/bin/brew
	-brew bundle --file=$(DOTFILE_DIR)/darwin/.Brewfile

brew-sync:
	brew bundle dump --force --file=$(DOTFILE_DIR)/darwin/.Brewfile

upgrade: brew-upgrade cask-upgrade

brew-upgrade:
	if brew upgrade ; then brew cleanup ; fi;

cask-upgrade:
	if brew cask upgrade ; then brew cleanup ; fi;

/usr/local/Homebrew/bin/brews:
	{ \
	set -e ;\
	if hash brew 2> /dev/null; then \
		echo "Brew is already installed."; \
	else \
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; \
	fi ;\
	}

font-cache:
	$(info Resetting system font-cache)
	$(shell fc-cache -f)

git-init:
	git submodule update --init --recursive

dev-tools: $(HOME)/.asdf

$(HOME)/enc-vol:
	mkdir -p $(HOME)/enc-vol

enc-vol: $(HOME)/enc-vol

mount-enc: $(HOME)/enc-vol
	veracrypt -t -k "" --pim=0 --protect-hidden=no enc/vol.vc $(HOME)/enc-vol

umount-enc:
	veracrypt -d $(HOME)/enc-vol

$(HOME)/.asdf:
	git clone https://github.com/asdf-vm/asdf.git $(HOME)/.asdf --branch v0.7.8

profile-source:
	source $(HOME)/.bash_profile

backup-bash:
	$(DOTFILE_DIR)/bash_backup.sh

#
## git installs.
#

git-install-hexyl:
	cd /tmp && \
	curl -Ls -o hexyl.deb "https://github.com/sharkdp/hexyl/releases/download/v0.6.0/hexyl_0.6.0_amd64.deb"; \
	sudo dpkg -i hexyl.deb;

git-install-bat:
	cd /tmp && \
	curl -Ls -o bat.deb "https://github.com/sharkdp/bat/releases/download/v0.12.1/bat_0.12.1_amd64.deb"; \
	sudo dpkg -i /tmp/bat.deb;

git-install-z:
	sudo git clone https://github.com/rupa/z.git --branch v1.11 /usr/local/lib/z

$(HOME)/.local/bin/op:
	gpg --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
	gpg --verify op.sig op
	curl -Ls -o op.

stow: backup-bash
	stow bash
	stow bin
	stow config
	stow fonts
	stow ssh
	stow tmux
	stow vim

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
