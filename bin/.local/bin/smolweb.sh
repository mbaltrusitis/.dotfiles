#!/usr/bin/env bash

readonly MAX="${1:-5}"

pages() {
	for _idx in $(seq 1 "$MAX"); do
		curl -sSw '%header{location}\n' https://indieblog.page/random | sed 's/.utm.*//'
	done
}

pages
