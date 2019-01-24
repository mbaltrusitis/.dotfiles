#!/bin/bash


function cleanup() {
	echo "I: Cleaning up"
	unset DEST
	unset GPG_KEY
	unset OLDEST_FULL_TIME
	unset PASSPHRASE
	unset RETENTION_TIME
	unset SIGN_PASSPHRASE
	unset SRC
}


echo "I: Starting backup."
if hash duplicity 2>/dev/null; then
	if duplicity \
		--asynchronous-upload \
		--encrypt-sign-key="$GPG_KEY" \
		--exclude-if-present=.nobackup \
		--full-if-older-than="$OLDEST_FULL_TIME" \
		"$SRC" \
		"$DEST"; then
		echo "I: Backup complete";
		echo "I: Verifying backup";
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
		echo "I: Verify complete."
	else
		echo "E: Could not verify backup."
		cleanup
		exit 1;
	fi


	echo "I: Truncating backups"
	if duplicity remove-older-than "$RETENTION_TIME" \
		--force \
		"$DEST"; then
		echo "I: Truncate complete";
	else
		echo "E: Truncate error"
		cleanup
		exit 1;
	fi;

	echo "I: Cleaning up backend for non-duplicity nonsense"
	if duplicity cleanup \
		--force \
		"$DEST"; then
		echo "I: Cleanup successful"
	else
		echo "E: Cleanup error"
		exit 1;
	fi;

	cleanup
	echo "I: 🎉Done🎉"
	exit 0;
else
	echo "E: Duplicity is not installed"
	cleanup
	exit 1
fi;

echo "E: Unknown error"
cleanup
exit 1;
