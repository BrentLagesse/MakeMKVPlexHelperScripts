#!/bin/bash

# Set the size threshold in bytes (e.g., 1024 for 1 KB)
SIZE_THRESHOLD=1000000000

DIR="."

while getopts d:s: flag
do
    case "${flag}" in
        s) SIZE_THRESHOLD=${OPTARG};;
	d) DIR=${OPTARG};;
    esac
done


# Define the temporary directory
TEMP_DIR="./temp"

# Create the temporary directory if it doesn't exist
mkdir -p "$DIR/$TEMP_DIR"

# Find and move mkv under the size threshold
find $DIR -maxdepth 1 -type f -size -"${SIZE_THRESHOLD}"c -name "*.mkv" -exec mv {} "$DIR/$TEMP_DIR" \;

echo "Files under $SIZE_THRESHOLD bytes have been moved to $TEMP_DIR."

