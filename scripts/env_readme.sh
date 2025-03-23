#!/bin/bash
# env_readme.sh
VERSION="0.0.3"  # Increment version as per user's advice

# Define the file path for persistent storage
ENV_README_FILE=".env_readme"

# Function to clean ENV_README by removing empty parts
clean_env_readme() {
  local parts=()
  IFS='::' read -ra temp <<< "$ENV_README"
  for part in "${temp[@]}"; do
    if [ -n "$part" ]; then
      parts+=("$part")
    fi
  done
  ENV_README=$(IFS='::'; echo "${parts[*]}")
}

# Function to load ENV_README from the file
load_env_readme() {
  if [ -f "$ENV_README_FILE" ]; then
    ENV_README=$(cat "$ENV_README_FILE")
    clean_env_readme
  else
    ENV_README="ERR=0"  # Default value
  fi
}

# Function to save ENV_README to the file
save_env_readme() {
  printf '%s\n' "$ENV_README" > "$ENV_README_FILE"
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
  # Clean after setting
  clean_env_readme
}

# Function to get the value of a key from ENV_README
get_env_readme_key() {
  local key=$1
  echo "$ENV_README" | tr '::' '\n' | grep "^$key=" | cut -d'=' -f2-
}

# Testing and Debugging Section
# This section runs only if the script is executed directly (not sourced)
if [ "$0" = "$BASH_SOURCE" ]; then
  # Test 1: Load ENV_README
  echo "--- Test 1: Load ENV_README ---"
  load_env_readme
  echo "Loaded ENV_README: $ENV_README"

  # Test 2: Set key-value pairs
  echo "--- Test 2: Set key-value pairs ---"
  set_env_readme_key "_ERR" "0"
  set_env_readme_key "_DIR" "$(pwd)"
  set_env_readme_key "_VER" "$VERSION"
  set_env_readme_key "_BUG" "0"
  set_env_readme_key "_BAS" "README.md"
  set_env_readme_key "_STR" "${HOME}/Documents/Templates"
  set_env_readme_key "_ENV" ".test_readme"
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
  echo "_ERR: $(get_env_readme_key "_ERR")"
  echo "_DIR: $(get_env_readme_key "_DIR")"
  echo "_VER: $(get_env_readme_key "_VER")"
  echo "_BUG: $(get_env_readme_key "_BUG")"
  echo "_BAS: $(get_env_readme_key "_BAS")"
  echo "_STR: $(get_env_readme_key "_STR")"
  echo "_ENV: $(get_env_readme_key "_ENV")"

  # Test 6: Update an existing key
  echo "--- Test 6: Update an existing key ---"
  set_env_readme_key "_ERR" "1"
  echo "ENV_README after updating _ERR: $ENV_README"
  echo "_ERR: $(get_env_readme_key "_ERR")"

  # Test 7: Handle non-existent key
  echo "--- Test 7: Handle non-existent key ---"
  echo "NON_EXISTENT_KEY: $(get_env_readme_key "NON_EXISTENT_KEY")"

  # Test 8: Save again
  echo "--- Test 8: Save updated ENV_README ---"
  save_env_readme
  echo "Saved to $ENV_README_FILE"
fi

# Backup function
backup_env_readme() {
  local backup_file="$ENV_README_FILE.bak_$(date +%Y%m%d_%H%M%S)"
  cp "$ENV_README_FILE" "$backup_file"
}