#!/bin/bash
# insert_readme.sh
version="0.0.7-1"
DATE=$(date '+%Y%m%d')

# Default locations and settings
BASE_TEMPLATE="README.md"
TEMPLATES_STORE="${HOME}/Documents/Templates"
FILE="README.md"
ENV_README="ERR=0::DIR=${TEMPLATES_STORE}::VER=${version}"

# Function to create a base template if missing
create_base_template() {
  local target="$1"
  echo "Creating base template at $target"
  cat >"$target" <<'EOF'
# Project README
<!-- ID: BASE-TEMPLATE-001 -->
This is a default README.md file created by insert_readme.sh v$version
EOF
}

# Determine target directory from Caja selection or current dir
if [ -n "$1" ]; then
  TARGET_DIR="$1" # Assume first argument is the selected folder from Caja
else
  TARGET_DIR="$(pwd)" # Default to current directory
fi

# Update FILE path to target directory
FILE="${TARGET_DIR}/${FILE}"

# Check and create template store directory if it doesn’t exist
if [ ! -d "$TEMPLATES_STORE" ]; then
  echo "Template store not found, creating: $TEMPLATES_STORE"
  mkdir -p "$TEMPLATES_STORE" || {
    echo "Error: Failed to create $TEMPLATES_STORE"
    ENV_README="ERR=1::DIR=${TEMPLATES_STORE}"
    exit 1
  }
fi

# Determine source template
if [ -z "$SRC" ]; then
  SRC="${TEMPLATES_STORE}/${BASE_TEMPLATE}"
fi

# Check if source template exists, create if missing
if [ ! -f "$SRC" ]; then
  echo "Warning: Template file not found at $SRC"
  create_base_template "$SRC"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to create base template"
    ENV_README="ERR=2::DIR=${TEMPLATES_STORE}"
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
  echo "[v$version] Successfully created $FILE"
  ENV_README="ERR=0::DIR=${TARGET_DIR}::VER=${version}::FILE=${FILE}"
else
  echo "Error: Failed to create $FILE"
  ENV_README="ERR=1::DIR=${TARGET_DIR}"
  exit 1
fi

# Persist ENV_README for the session
echo "export ENV_README=\"${ENV_README}\"" >"$HOME/.insert_readme_env"
source "$HOME/.insert_readme_env"
echo "Session info: $ENV_README"

# Attempt to refresh Caja (experimental)
# Note: Caja doesn't have a direct refresh command, so we try a workaround
touch "$TARGET_DIR" # Update directory timestamp
# Optional: Restart Caja (uncomment if needed, but disruptive)
# pkill -HUP caja

exit 0
