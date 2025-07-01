#!/usr/bin/env bash

# Parse arguments
url="$1"
category="${2:-miscellaneous}"

# Assert archive root path is set
if [[ -z "$VIDEO_ARCHIVE_ROOT" ]]; then
    echo "Error: the env var VIDEO_ARCHIVE_ROOT is not defined. Halting."
    exit 1
fi

# Validate category
case "$category" in
    music|documentary|miscellaneous|tutorial)
        ;;
    *)
        echo "Error: Invalid category '$category'. Must be one of: music, documentary, miscellaneous, tutorial" >&2
        exit 1
        ;;
esac

# Check if URL is provided
if [[ -z "$url" ]]; then
    echo "Usage: $0 <url> [category]" >&2
    echo "Categories: music, documentary, miscellaneous, tutorial (default: miscellaneous)" >&2
    exit 1
fi

# Determine output directory
output_dir="$VIDEO_ARCHIVE_ROOT/$category"
output_path="$output_dir/%(uploader)s - %(upload_date>%Y-%m-%d)s - %(title)s [%(id)s]/%(uploader)s - %(upload_date>%Y-%m-%d)s - %(title)s [%(id)s].%(ext)s"

# Create output directory if it doesn't exist and VIDEO_ARCHIVE_ROOT is set
if [[ ! -d "$output_dir" ]]; then
    mkdir -p "$output_dir"
fi

capitalized_category=$(echo "$category" | sed 's/./\U&/')

yt-dlp \
    -f "bestvideo+bestaudio/best" \
    --merge-output-format mp4 \
    -o "$output_path" \
    --write-info-json \
    --write-sub --sub-lang en \
    --write-thumbnail \
    --embed-thumbnail --embed-subs \
    --ignore-errors \
    --no-continue \
    --no-overwrites \
    --add-metadata \
    --download-archive "$VIDEO_ARCHIVE_ROOT/.yt-dlp-archive" \
    --parse-metadata "%(uploader)s:%(artist)s" \
    --parse-metadata "$capitalized_category:%(genre)s" \
    --parse-metadata "%(upload_date>%Y-%m-%d)s:%(date)s" \
    --parse-metadata "%(upload_date>%Y)s:%(year)s" \
    --parse-metadata "%(title)s:%(track)s" \
    --parse-metadata "%(description)s:%(plot)s" \
    --parse-metadata "%(webpage_url)s:%(purl)s" \
	--sleep-requests 1.25 \
	--min-sleep-interval 60 \
	--max-sleep-interval 90 \
    "$url"
