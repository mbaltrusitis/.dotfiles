#!/bin/bash

echo "I: Install AUR packages";
pamac build --no-confirm \
	archlinux-nix \
	fswatch \
	google-cloud-sdk \
	magic-wormhole-git \
	mailspring \
	mycli \
	nix \
	pgcli \
	tmux-bash-completion \
	wuzz;
