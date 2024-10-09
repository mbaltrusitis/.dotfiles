# vim: filetype=make
# The main entrypoint for .dotfiles
#
# This Makefile will attempt to detect if the client targeted for configuration
# is headless or has a GNOME desktop environment. In the case of a headless-only
# client, it wil target only the `headless` goal. When a GNOME desktop
# environment is detected, it will target both the `headless` and `desktop`
# goals.

.ONESHELL:

SHELL := /bin/bash
.SHELLFLAGS := -e -c

DOTFILE_DIR	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
IS_GNOME := $(shell if [[ $(XDG_CURRENT_DESKTOP) = *"GNOME"* ]]; then echo 0; else echo 1; fi)

# make utility functions available to all goals
export BASH_ENV := ./utils/bash-utils.bash
# export variables for use by child makefiles
export SHELL := $(SHELL)
export DOTSHELLFLAGS := $(.SHELLFLAGS)
export DOTFILE_DIR := $(DOTFILE_DIR)
export OS := $(OS)

ifeq ($(IS_GNOME),0)
all: disable-sleep prepare desktop gnome enable-sleep
else
all: prepare headless
endif

# prelude start
prepare: _build git-init backup-bash stow
	@LOG_DEBUG "Running prepare"
	sudo apt-get install --yes \
.PHONY: prepare

_build:
	mkdir -p ./_build

dotfiles-deps:
	sudo apt-get update
	sudo apt-get install \
		curl \
		git
.PHONY: dotfiles-deps

git-init:
	git submodule update --init --recursive

# prelude final

backup-bash:
	./utils/bash_backup.sh
.PHONY: backup-bash

# handlers start
disable-sleep:
	LOG_INFO "Enabling desktop screensaver and lock"
	@gsettings set org.gnome.desktop.screensaver lock-enabled false
	@gsettings set org.gnome.desktop.session idle-delay 0
.PHONY: disable-sleep

enable-sleep:
	LOG_INFO "Re-enabling desktop screensaver and lock"
	@gsettings set org.gnome.desktop.screensaver lock-enabled true
	@gsettings set org.gnome.desktop.session idle-delay 300
.PHONY: enable-sleep

font-cache:
	$(info Resetting system font-cache)
	fc-cache -f
.PHONY: font-cache
# handlers final

desktop: headless
	LOG_INFO "Running desktop install"
	$(MAKE) -f ./Makefile.desktop
.PHONY: desktop

gnome:
	$(MAKE) -f ./Makefile.gnome
.PHONY: gnome

headless:
	LOG_INFO "Running headless install"
	$(MAKE) -f ./Makefile.headless
.PHONY: headless

macos:
	LOG_ERROR "Unsupported platform"
	exit 1
.PHONY: macos

stow:
	stow --restow bash
	stow --restow bin
	stow --restow config
	stow --restow fonts
	stow --restow ssh
	stow --restow tmux
.PHONY: stow

unstow:
	stow --delete bash
	stow --delete bin
	stow --delete config
	stow --delete fonts
	stow --delete ssh
	stow --delete tmux
.PHONY: unstow

help:
	@echo "help yourself :P"
.PHONY: help
