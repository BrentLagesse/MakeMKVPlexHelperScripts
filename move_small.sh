#!/bin/bash

# Set the size threshold in bytes (e.g., 1024 for 1 KB)
SIZE_THRESHOLD=1000000000

# Define the temporary directory
TEMP_DIR="./temp"

# Create the temporary directory if it doesn't exist
mkdir -p "$TEMP_DIR"

# Find and move mkv under the size threshold
find . -maxdepth 1 -type f -size -"${SIZE_THRESHOLD}"c -name "*.mkv" -exec mv {} "$TEMP_DIR" \;

echo "Files under $SIZE_THRESHOLD bytes have been moved to $TEMP_DIR."

