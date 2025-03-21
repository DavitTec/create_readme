#!/bin/bash
version=0.2

# Source template file
SRC="../src/Templates/README.md"
# Current date in YYYYMMDD format
DATE=$(date '+%Y%m%d')
# Default output filename
FILE="README.md"

# Check if source template exists
if [ ! -f "$SRC" ]; then
    echo "Error: Template file not found at $SRC"
    exit 1
fi

# If README.md exists, create a dated version instead
if [ -f "$FILE" ]; then
    FILE="${DATE}-README.md"
    echo "Existing README.md found, creating $FILE instead"
else
    echo "[v$version] Creating new README.md"
fi

# Copy the template and check if the operation was successful
if cp -n "$SRC" "$FILE"; then
    echo "Successfully created $FILE"
else
    echo "Error: Failed to create $FILE"
    exit 1
fi

exit 0
