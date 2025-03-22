#!/bin/bash
version=0.5

# Source template file
SRC="/home/david/Templates/markdown/README_0.md"
# Current date in YYYYMMDD format
DATE=$(date '+%Y%m%d')
# Default output filename
FILE="README.md"

# Check if source template exists
if [ ! -f "$SRC" ]; then
  echo "Error: Template file not found at $SRC"
  exit 1
fi

# If file exists, create a dated version instead
if [ -f "$FILE" ]; then
  msg="Existing $FILE found, creating "
  FILE="${DATE}-README.md"
  echo "$msg $FILE instead"
else
  echo "[v$version] Creating new README.md"
fi

# Copy the template, rename and check if the operation was successful
if cp -n "$SRC" "$FILE"; then
  echo "Successfully created $FILE"
else
  echo "Error: Failed to create $FILE"
  exit 1
fi

exit 0
