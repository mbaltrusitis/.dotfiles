#!/bin/bash


function cleanup() {
	unset DEST
	unset GPG_KEY
	unset OLDEST_FULL_TIME
	unset PASSPHRASE
	unset RETENTION_TIME
	unset SIGN_PASSPHRASE
	unset SRC
}


if hash duplicity 2>/dev/null; then
	if duplicity \
		--asynchronous-upload \
		--encrypt-sign-key="$GPG_KEY" \
		--exclude-if-present=.nobackup \
		--full-if-older-than="$OLDEST_FULL_TIME" \
		"$SRC" \
		"$DEST"; then
		:
	else
		echo "E: Backup error"
		cleanup
		exit 1;
	fi;

	if duplicity verify \
		--encrypt-sign-key="$GPG_KEY" \
		--exclude-if-present=.nobackup \
		"$DEST" \
		"$SRC"; then
		:;
	else
		echo "E: Could not verify backup."
		cleanup
		exit 1;
	fi


	if duplicity remove-older-than "$RETENTION_TIME" \
		--force \
		"$DEST"; then
		:;
	else
		echo "E: Truncate error"
		cleanup
		exit 1;
	fi;

	if duplicity cleanup \
		--force \
		"$DEST"; then
		:;
	else
		echo "E: Cleanup error"
		exit 1;
	fi;

	cleanup
	exit 0;
else
	echo "E: Duplicity is not installed"
	cleanup
	exit 1
fi;

echo "E: Unknown error"
cleanup
exit 1;
