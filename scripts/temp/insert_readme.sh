#!/bin/bash
# insert_readme.sh
VERSION="0.0.7-4"
DATE=$(date '+%Y%m%d')

# Source env_readme.sh
source "./env_readme.sh"
load_env_readme

# Set initial keys
set_env_readme_key "ERR" "0"
set_env_readme_key "DIR" "$(pwd)"
set_env_readme_key "VER" "$VERSION"

# Default locations and settings
BASE_TEMPLATE="README.md"
TEMPLATES_STORE="${HOME}/Documents/Templates"

# Function to create a base template if missing
create_base_template() {
    local target="$1"
    echo "Creating base template at $target"
    cat >"$target" <<EOF
# Project README

<!-- ID: BASE-TEMPLATE-001 -->

This is a default README.md file created by insert_readme.sh v$VERSION
EOF
}

# Determine target directory from Caja argument or current dir
TARGET_DIR="${1:-$(pwd)}"
FILE="${TARGET_DIR}/README.md"

# Ensure target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory $TARGET_DIR does not exist"
    set_env_readme_key "ERR" "1"
    exit 1
fi

# Check and create template store directory
if [ ! -d "$TEMPLATES_STORE" ]; then
    echo "Template store not found, creating: $TEMPLATES_STORE"
    mkdir -p "$TEMPLATES_STORE" || {
        echo "Error: Failed to create $TEMPLATES_STORE"
        set_env_readme_key "ERR" "1"
        exit 1
    }
fi

# Determine source template
SRC="${TEMPLATES_STORE}/${BASE_TEMPLATE}"

# Check if source template exists, create if missing
if [ ! -f "$SRC" ]; then
    echo "Warning: Template file not found at $SRC"
    create_base_template "$SRC"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create base template"
        set_env_readme_key "ERR" "2"
        exit 1
    fi
    echo "Created new base template at $SRC"
fi

# Handle existing file in target location
if [ -f "$FILE" ]; then
    echo "Existing $FILE found, creating dated version instead"
    FILE="${TARGET_DIR}/${DATE}-README.md"
fi

# Copy the template and verify
if cp -n "$SRC" "$FILE"; then
    echo "[v$VERSION] Successfully created $FILE"
    set_env_readme_key "FILE" "$FILE"
else
    echo "Error: Failed to create $FILE"
    set_env_readme_key "ERR" "1"
    exit 1
fi

# Save ENV_README
save_env_readme

exit 0
