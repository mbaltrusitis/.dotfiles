# vim: filetype=make
# The main entrypoint for .dotfiles
#
# This Makefile will attempt to detect if the client targeted for configuration
# is headless or has a GNOME desktop environment. In the case of a headless-only
# client, it wil target only the `headless` goal. When a GNOME desktop
# environment is detected, it will target both the `headless` and `desktop`
# goals.

.ONESHELL:
MAKEFLAGS += --no-print-directory

SHELL := /bin/bash
.SHELLFLAGS := -e -c

DOTFILE_DIR	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
IS_GNOME := $(shell if [[ $(XDG_CURRENT_DESKTOP) = *"GNOME"* ]]; then echo 0; else echo 1; fi)

# make utility functions available to all goals
export BASH_ENV := ./utils/bash_utils.bash
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
.PHONY: prepare

_build:
	@mkdir -p ./_build

dotfiles-deps:
	@sudo apt-get update
	sudo apt-get install \
		curl \
		git
.PHONY: dotfiles-deps

git-init:
	@git submodule update --init --recursive
.PHONY: git-init

backup-bash:
	@if [ ! -L "$(HOME)/.bashrc" ]; then ./utils/bash_backup.sh; fi
.PHONY: backup-bash
# prelude final

# handlers start
disable-sleep:
	@LOG_DEBUG "Enabling desktop screensaver and lock"
	@gsettings set org.gnome.desktop.screensaver lock-enabled false
	@gsettings set org.gnome.desktop.session idle-delay 0
.PHONY: disable-sleep

enable-sleep:
	@LOG_DEBUG "Re-enabling desktop screensaver and lock"
	@gsettings set org.gnome.desktop.screensaver lock-enabled true
	@gsettings set org.gnome.desktop.session idle-delay 300
.PHONY: enable-sleep

font-cache:
	@LOG_INFO "Resetting system font-cache"
	fc-cache -f
.PHONY: font-cache
# handlers final

desktop: headless
	@LOG_INFO "Running desktop install"
	@$(MAKE) -f ./Makefile.desktop
	@LOG_INFO "Completed desktop install"
.PHONY: desktop

gnome:
	@LOG_INFO "Running GNOME setup"
	@$(MAKE) -f ./Makefile.gnome
	@LOG_INFO "Completed GNOME setup"
.PHONY: gnome

headless:
	@LOG_INFO "Running headless install"
	@$(MAKE) -f ./Makefile.headless
	@LOG_INFO "Completed headless install"
.PHONY: headless

asdf:
	@$(MAKE) -f ./Makefile.asdf
.PHONY: asdf

ai:
	@$(MAKE) -f ./Makefile.ai
.PHONY: ai

macos:
	@LOG_ERROR "Unsupported platform"
	@exit 1
.PHONY: macos

STOW_PACKAGES := bash bin config fonts ssh tmux

stow:
	@stow --restow $(STOW_PACKAGES) 2>&1 | grep -v 'BUG in find_stowed_path' || true
.PHONY: stow

upgrade:
	@sudo apt-get upgrade
	@flatpak update
.PHONY: upgrade

unstow:
	@stow --delete $(STOW_PACKAGES) 2>&1 | grep -v 'BUG in find_stowed_path' || true
.PHONY: unstow

ledger:
	$(MAKE) -f ./Makefile.desktop ledger-live
.PHONY: ledger

help:
	@echo "help yourself :P"
.PHONY: help
