#!/bin/bash
# insert_readme.sh
version="0.0.7-0" # Updated to match your latest version
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

# Determine source template
if [ -z "$SRC" ]; then
  SRC="${TEMPLATES_STORE}/${BASE_TEMPLATE}"
fi

# Check and create template store directory if it doesn't exist
if [ ! -d "$TEMPLATES_STORE" ]; then
  echo "Template store not found, creating: $TEMPLATES_STORE"
  mkdir -p "$TEMPLATES_STORE" || {
    echo "Error: Failed to create $TEMPLATES_STORE"
    ENV_README="ERR=1::DIR=${TEMPLATES_STORE}"
    exit 1
  }
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
  FILE="${DATE}-README.md"
fi

# Copy the template and verify
if cp -n "$SRC" "$FILE"; then
  echo "[v$version] Successfully created $FILE"
  ENV_README="ERR=0::DIR=${TEMPLATES_STORE}::VER=${version}::FILE=${FILE}"
else
  echo "Error: Failed to create $FILE"
  ENV_README="ERR=1::DIR=${TEMPLATES_STORE}"
  exit 1
fi

# Export session environment variable
export ENV_README
echo "Session info: $ENV_README"

exit 0
