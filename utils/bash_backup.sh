#!/usr/bin/env bash

set -euo pipefail

# empty GLOBs initialize to null strings
shopt -s nullglob

source ./utils/bash_utils.bash

TARGET_DIR="${1:-$HOME}"
TARGET_FILES=("$TARGET_DIR/.bash*")

BACKUP_BATCH_ID=$(date '+%Y%m%dT%H%M%S')

LOG_INFO "Moving or unlinking Bash-related files in $TARGET_DIR"

for file in "${TARGET_FILES[@]}"; do
	if [ "$file" = "$TARGET_DIR/.bash_history" ]; then
		LOG_INFO "Skipping .bash_history"
	elif [ -h "$file" ]; then
		LOG_INFO "Unlinking symbolic link: $file"
		if rm "$file"; then
			LOG_INFO "Successfully unlinked $file"
		else
			LOG_ERROR "Failed to unlink $file" >&2
		fi
	elif [ -f "$file" ]; then
		mkdir -p "$BACKUP_BATCH_ID"
		backup_file="$BACKUP_BATCH_ID/$file.backup"
		LOG_INFO "Moving $file to $backup_file"
		if mv "$file" "$backup_file"; then
			LOG_INFO "Successfully moved $file to $backup_file"
		else
			LOG_ERROR "Failed to move $file to $backup_file" >&2
		fi
	fi
done

LOG_INFO "done."
