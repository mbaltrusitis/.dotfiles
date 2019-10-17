.PHONY: all apt backup-bash brew-sync darwin dev-tools enc-vol git-init help install link linux nodejs-dev scala-dev profile-source \
	python-dev snap stow unlink venv-wrapper
.ONESHELL:

SHELL		= /bin/bash
DOTFILE_DIR	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OS			:= $(shell uname -s | tr '[:upper:]' '[:lower:]')


all: install
install: $(OS)
linux: apt flatpak git-init stow dev-tools profile-source font-cache
darwin: brew brew-upgrade git-init stow profile-source


apt:
	$(info You may be prompted for super-user privleges:)
	sudo linux/apt-update.sh
	sudo linux/apt-minimal.sh
	sudo linux/apt-full.sh
	sudo linux/apt-ppa.sh

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

flatpak:
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

font-cache:
	$(info Resetting system font-cache)
	$(shell fc-cache -f)

git-init:
	git submodule update --init --recursive

dev-tools: $(HOME)/.asdf # $(HOME)/.kubectx

$(HOME)/enc-vol:
	mkdir -p $(HOME)/enc-vol

enc-vol: $(HOME)/enc-vol

mount-enc: $(HOME)/enc-vol
	veracrypt $(HOME)/vol.vc $(HOME)/enc-vol

umount-enc:
	veracrypt -d $(HOME)/enc-vol

python-dev: $(HOME)/.pyenv venv-wrapper
nodejs-dev: $(HOME)/.nodenv $(HOME)/.nodenv/plugins/node-build
scala-dev:  $(HOME)/.scalaenv $(HOME)/.sbtenv

$(HOME)/.asdf:
	git clone https://github.com/asdf-vm/asdf.git $(HOME)/.asdf --branch v0.7.4

$(HOME)/.scalaenv:
	git clone git://github.com/scalaenv/scalaenv.git $(HOME)/.scalaenv

$(HOME)/.sbtenv:
	git clone git://github.com/sbtenv/sbtenv.git $(HOME)/.sbtenv

$(HOME)/.nodenv:
	git clone https://github.com/nodenv/nodenv.git $(HOME)/.nodenv
	$(shell cd $HOME/.nodenv && src/configure && make -C src)

$(HOME)/.nodenv/plugins/node-build:
	git clone https://github.com/nodenv/node-build.git $(HOME)/.nodenv/plugins/node-build

$(HOME)/.pyenv:
	git clone https://github.com/pyenv/pyenv.git $(HOME)/.pyenv

venv-wrapper:
	pip3 install --user -U virtualenvwrapper virtualenv

profile-source:
	source $(HOME)/.bash_profile

backup-bash:
	$(DOTFILE_DIR)/bash_backup.sh

stow: backup-bash
	stow bash
	stow bin
	stow config
	stow fonts
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
