# The main entrypoint for .dotfiles
#
# When is desktop installed? When is terminal installed?

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

all: install
install: $(OS)
linux: git-init stow dev-tools

packages: apt flatpak

# prelude start
prepare: _build git-init backup-bash stow
	@LOG_DEBUG "Running prepare"
.PHONY: prepare

git-init:
	git submodule update --init --recursive

_build:
	mkdir -p ./_build
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

desktop: disable-sleep headless
	LOG_INFO "Running desktop install"
	$(MAKE) -f ./Makefile.desktop
	$(MAKE) enable-sleep
.PHONY: desktop

headless:
	LOG_INFO "Running headless install"
	$(MAKE) -f ./Makefile.headless
.PHONY: headless

macos:
	LOG_ERROR "Unsupported platform"
	exit 1
.PHONY: macos

stow:
	stow --restow --dotfiles bash
	stow --restow --dotfiles bin
	stow --restow --dotfiles config
	stow --restow --dotfiles fonts
	stow --restow --dotfiles ssh
	stow --restow --dotfiles tmux
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
