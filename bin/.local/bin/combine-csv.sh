#!/bin/bash

# Check if a pattern argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <pattern>"
    echo "Example: $0 '~/Downloads/foo-*.csv'"
    exit 1
fi

# Get the pattern from the command line argument
pattern=$1
name=${2:-"combined"}

# Get the current date in YYYYMMDD format
output_date=$(date +%Y%m%d)

# Define the output file name in the current working directory
output_file="$name-$output_date.csv"

# Check if files matching the pattern exist
if ls "$pattern" 1> /dev/null 2>&1; then
    # Print the header from the first file
    head -n 1 $(ls "$pattern" | head -n 1) > "$output_file"

    # Loop through files and append their content minus the header
    for file in $pattern; do
        tail -n +2 "$file" >> "$output_file"
    done

    echo "Files have been combined into $output_file"
else
    echo "No files matching the pattern were found."
fi
