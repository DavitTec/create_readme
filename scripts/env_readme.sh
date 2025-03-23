#!/bin/bash
# env_readme.sh
VERSION="0.0.2" # Script version

# Define the file path for persistent storage
ENV_README_FILE=".env_readme"

# Function to load ENV_README from the file
load_env_readme() {
  if [ -f "$ENV_README_FILE" ]; then
    ENV_README=$(cat "$ENV_README_FILE")
  else
    ENV_README=""
  fi
}

# Function to save ENV_README to the file
save_env_readme() {
  printf '%s\n' "$ENV_README" >"$ENV_README_FILE"
}

# Function to set a key-value pair in ENV_README
set_env_readme_key() {
  local key=$1
  local value=$2
  # Remove existing key if present
  ENV_README=$(echo "$ENV_README" | sed "s/$key=[^:]*//")
  # Add new key-value
  if [ -n "$ENV_README" ]; then
    ENV_README="$ENV_README::$key=$value"
  else
    ENV_README="$key=$value"
  fi
}

# Function to get the value of a key from ENV_README
get_env_readme_key() {
  local key=$1
  echo "$ENV_README" | tr '::' '\n' | grep "^$key=" | cut -d'=' -f2-
}

# Testing and Debugging Section
# This section runs only if the script is executed directly (not sourced)
if [ "$0" = "$BASH_SOURCE" ]; then
  # Test 1: Load existing ENV_README (if any)
  echo "--- Test 1: Load ENV_README ---"
  load_env_readme
  echo "Loaded ENV_README: $ENV_README"

  # Test 2: Set key-value pairs
  echo "--- Test 2: Set key-value pairs ---"
  set_env_readme_key "ERR" "0"
  set_env_readme_key "DIR" "$(pwd)"
  set_env_readme_key "VER" "$VERSION"
  echo "ENV_README after setting keys: $ENV_README"

  # Test 3: Save ENV_README
  echo "--- Test 3: Save ENV_README ---"
  save_env_readme
  echo "Saved to $ENV_README_FILE"

  # Test 4: Load and verify
  echo "--- Test 4: Load and verify ---"
  load_env_readme
  echo "Loaded ENV_README: $ENV_README"

  # Test 5: Get specific keys
  echo "--- Test 5: Get specific keys ---"
  echo "ERR: $(get_env_readme_key "ERR")"
  echo "DIR: $(get_env_readme_key "DIR")"
  echo "VER: $(get_env_readme_key "VER")"

  # Test 6: Update an existing key
  echo "--- Test 6: Update an existing key ---"
  set_env_readme_key "ERR" "1"
  echo "ENV_README after updating ERR: $ENV_README"
  echo "ERR: $(get_env_readme_key "ERR")"

  # Test 7: Handle non-existent key
  echo "--- Test 7: Handle non-existent key ---"
  echo "NON_EXISTENT_KEY: $(get_env_readme_key "NON_EXISTENT_KEY")"

  # Test 8: Save again
  echo "--- Test 8: Save updated ENV_README ---"
  save_env_readme
  echo "Saved to $ENV_README_FILE"
fi

# Backup: function to env_readme.sh for safety:
backup_env_readme() {
  local backup_file="$ENV_README_FILE.bak_$(date +%Y%m%d_%H%M%S)"
  cp "$ENV_README_FILE" "$backup_file"
}
