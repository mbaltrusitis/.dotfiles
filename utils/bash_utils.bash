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

import_pgp_key_by_file() {
	LOG_DEBUG "Attempting to import PGP key from: $1"
	# shellcheck disable=SC2211
	if is_installed "gpg"; then
		if gpg --import "$1"; then
			LOG_INFO "Successfully imported key"
		else
			LOG_ERROR "Failed to import key"
		fi
	else
		LOG_ERROR "gpg needs to be installed. Halting."
		exit 1
	fi
}

get_latest_github_release_version() {
	repo_url="$1"
	declare -r latest_version="$(curl -s -w '%{redirect_url}\n' "$repo_url/releases/latest" \
		| cut -d'/' -f8 | cut -c2- )"
	echo "$latest_version"
}

download_github_release_artifact() {
	local download_dir="$1"
	local github_repo="$2"
	local version=${4:-$(get_latest_github_release_version "$github_repo")}
	local raw_artifact_name="$3"
	local download_path_full="$1/$3"
	# replace instances of $version with the $version variable
	local artifact_name="${raw_artifact_name//\$version/$version}"

	mkdir -p "$download_dir"

	LOG_INFO "Downloading version $version of $artifact_name to $download_path"
	declare -r download_target="$github_repo/releases/download/$version/$artifact_name"

	if curl -sSLo "$download_path" "$download_target"; then
		LOG_INFO "Successfully downloaded $artifact_name to $download_path"
		return 0
	else
		LOG_ERROR "Failed to download $artifact_name"
		return 1
	fi
}

maybe_unlink_link() {
	declare -r link_path="$1"
	if [[ -L $link_path ]]; then
		LOG_INFO "Unlinking link at $link_path"
		sudo unlink "$link_path"
	else
		LOG_WARNING "No link to unlink at $link_path"
	fi
}
