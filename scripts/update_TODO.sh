#!/bin/bash

# update_TODO.sh (VERSION 0.0.2)
# Script to update ToDo.md with script information from ./scripts/ folder
# Supports testing mode with ./docs/test/ToDo.md

# Configuration
VERSION="0.0.2"
SOURCE_DIR="./scripts"
DOCS_DIR="./docs"
TEST_DIR="./docs/test"
TODO_FILE="$DOCS_DIR/ToDo.md"
TEMP_FILE="$TODO_FILE.tmp"
TEST_TODO_FILE="$TEST_DIR/ToDo.md"
TEST_TEMP_FILE="$TEST_TODO_FILE.tmp"
DELETE_FLAG=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -d | --delete)
    DELETE_FLAG="true"
    shift
    ;;
  *)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac
done

# Determine mode (testing or live)
if [ -d "$TEST_DIR" ] && [ -f "$TEST_TODO_FILE" ]; then
  MODE="test"
  TARGET_TODO="$TEST_TODO_FILE"
  TARGET_TEMP="$TEST_TEMP_FILE"
  echo "Running in TEST mode: Updating $TARGET_TODO"
else
  MODE="live"
  TARGET_TODO="$TODO_FILE"
  TARGET_TEMP="$TEMP_FILE"
  echo "Running in LIVE mode: Updating $TARGET_TODO"
fi

# Check if required directories and files exist
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Scripts directory not found at $SOURCE_DIR"
  exit 1
fi

if [ ! -f "$TARGET_TODO" ]; then
  echo "Error: ToDo.md not found at $TARGET_TODO"
  exit 1
fi

# Function to extract documentation
get_Docs() {
  local script_file="$1"
  local output=""

  if [[ "${script_file: -3}" != ".sh" ]]; then
    return 1
  fi

  local docs_file="$(basename "$script_file" .sh).md"
  local script_docs="${DOCS_DIR}/${docs_file}"

  if [ -f "$script_docs" ]; then
    output="$script_docs"
  elif [ -f "$DOCS_DIR/help.md" ]; then
    output="$DOCS_DIR/help.md"
  else
    output="No documentation available"
  fi

  echo "$output"
}

# Function to extract info from script files
extract_script_info() {
  local file="$1"
  local basename=$(basename "$file")
  local name="${basename}"
  local state="unknown"
  local version="0.0.0"
  local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
  local docs=$(get_Docs "$file")
  local author="unknown"

  # Read file content and extract information
  while IFS= read -r line; do
    if [[ "$line" =~ VERSION[[:space:]]*=[[:space:]]*\"?([0-9]+\.[0-9]+\.[0-9]+)\"? ]]; then
      version="${BASH_REMATCH[1]}"
    fi
    if [[ "$line" =~ Author:[[:space:]]*(.*) ]]; then
      author="${BASH_REMATCH[1]}"
    fi
    if [[ "$line" =~ State:[[:space:]]*(.*) ]]; then
      state="${BASH_REMATCH[1]}"
    fi
  done <"$file"

  echo "name:$name|state:$state|version:$version|size:$size|docs:$docs|author:$author"
}

# Build scripts object (associative array)
declare -A scripts

# Process each script file
index=1
for script_file in "$SOURCE_DIR"/*; do
  if [ -f "$script_file" ]; then
    info=$(extract_script_info "$script_file")
    scripts["SCRIPT_NAME($index)"]=$(echo "$info" | cut -d'|' -f1 | cut -d':' -f2)
    scripts["SCRIPT_STATE($index)"]=$(echo "$info" | cut -d'|' -f2 | cut -d':' -f2)
    scripts["VERSION($index)"]=$(echo "$info" | cut -d'|' -f3 | cut -d':' -f2)
    scripts["SCRIPT_LOCATION($index)"]="$script_file"
    scripts["SCRIPT_DOCS($index)"]=$(echo "$info" | cut -d'|' -f5 | cut -d':' -f2)
    scripts["SCRIPT_AUTHOR($index)"]=$(echo "$info" | cut -d'|' -f6 | cut -d':' -f2)
    ((index++))
  fi
done

# Update ToDo.md
while IFS= read -r line; do
  new_line="$line"
  # Replace §VARIABLES with actual values
  for key in "${!scripts[@]}"; do
    if [[ "$new_line" =~ §"$key" ]]; then
      value="${scripts[$key]}"
      new_line="${new_line//§$key/$value}"
    fi
  done
  echo "$new_line"
done <"$TARGET_TODO" >"$TARGET_TEMP"

# Replace original file with updated version
mv "$TARGET_TEMP" "$TARGET_TODO"

# Handle test mode cleanup
if [ "$MODE" = "test" ] && [ "$DELETE_FLAG" = "true" ]; then
  rm -rf "$TEST_DIR"
  echo "Test directory $TEST_DIR deleted"
fi

echo "Updated $TARGET_TODO successfully"
exit 0
