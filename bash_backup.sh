#!/bin/bash

TARGET_DIR="${1-$HOME}"
TARGET_FILES="$TARGET_DIR/.bash*"

echo "Moving or unlinking Bash-related files in $TARGET_DIR"
echo ""

for file in $TARGET_FILES; do
	if [ "$file" == "$TARGET_DIR/.bash_history" ]; then
		echo "Skipping .bash_history";
	elif [ -h "$file" ]; then
		echo "Unlinking symbolic link: $file"
		unlink "$file"
	elif [ -f "$file" ]; then
		echo "Moving $file to ${file}.BK";
		echo ""
		mv "$file" "${file}.backup";
	fi
done

echo "done."
exit 0
