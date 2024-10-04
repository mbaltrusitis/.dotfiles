# Bash utility functions.
#
# This file is meant to be sourced from other bash scripts.

# logger helpers
LOG_DEBUG() { printf "\e[0;34m[DEBUG] %s\e[0m\n" "$1" ; }
LOG_INFO() { printf "\e[0;32m[INFO]  %s\e[0m\n" "$1" ; }
LOG_ERROR() { printf "\e[0;31m[ERROR] %s\e[0m\n" "$1" ; }
LOG_WARNING() { printf "\e[0;33m[WARN]  %s\e[0m\n" "$1" ; }

is_installed() {
	if hash "$1" 2>/dev/null; then
		return 0  # installed
	else
		return 1  # not installed
	fi
}

import_pgp_key_by_url() {
	LOG_DEBUG "Attempting to import PGP key from: $1"
	# shellcheck disable=SC2211
	if is_installed "gpg"; then
		if curl -sSL "$1" | gpg --import; then
			LOG_INFO "Successfully imported key"
		else
			LOG_ERROR "Failed to import key"
		fi
	else
		LOG_ERROR "gpg needs to be installed. Halting."
		exit 1
	fi
}
