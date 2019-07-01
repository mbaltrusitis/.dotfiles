#!/bin/bash

TARGET_DIR="${1-$HOME}/.bash*"

echo "Moving or unlinking Bash-related files in $TARGET_DIR"
echo ""

for file in $TARGET_DIR; do
	if [ "$file" == "**/.bash_history" ]; then
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
