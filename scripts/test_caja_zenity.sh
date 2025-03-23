#!/bin/bash

# test_caja_zenity.sh
VERSION="0.0.1"
TEMPLATE_DIR="$HOME/Templates/markdown"
DEFAULT_TEMPLATE="basic.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATUS_FILE="$HOME/.caja_script_status" # Persistent status file

# Debug function
debug() {
  echo "DEBUG: $1" >&2
}

# Ensure Zenity is installed
if ! command -v zenity &>/dev/null; then
  echo "Error: Zenity is required but not installed" >&2
  exit 1
fi

# Function to setup template
setup_template() {
  mkdir -p "$TEMPLATE_DIR"
  if [ ! -f "$TEMPLATE_DIR/$DEFAULT_TEMPLATE" ]; then
    cat <<EOF >"$TEMPLATE_DIR/$DEFAULT_TEMPLATE"
# Test Project

## Description
This is a test README.

## Version
$VERSION
EOF
  fi
}

# Function to determine context
get_context() {
  local context
  if [ -n "$CAJA_SCRIPT_SELECTED_FILE_PATHS" ]; then
    context="${CAJA_SCRIPT_SELECTED_FILE_PATHS%%$'\n'*}"
    debug "Caja context: Selected path is $context"
  else
    context="$PWD"
    debug "No Caja context: Falling back to current directory $context"
  fi

  if [ -f "$context" ]; then
    context="$(dirname "$context")"
    debug "Selected a file, using parent directory: $context"
  fi

  if [ ! -d "$context" ]; then
    debug "Invalid context: $context is not a directory"
    echo ""
    return 1
  fi

  debug "Determined context: $context"
  echo "$context"
}

# Function to create README
create_readme() {
  local target_dir="$1"
  local output_file="$target_dir/README.md"

  debug "Creating README at $output_file"

  if [ ! -d "$target_dir" ]; then
    debug "Target directory $target_dir does not exist"
    zenity --error --title="Error" --text="Target directory $target_dir does not exist"
    echo "ERROR: Target directory does not exist" >"$STATUS_FILE"
    return 1
  fi

  cp "$TEMPLATE_DIR/$DEFAULT_TEMPLATE" "$output_file" || {
    debug "Failed to copy template to $output_file"
    zenity --error --title="Error" --text="Failed to create $output_file"
    echo "ERROR: Failed to create $output_file" >"$STATUS_FILE"
    return 1
  }
  chmod 644 "$output_file"

  if [ -f "$output_file" ]; then
    debug "README created successfully at $output_file"
    zenity --info --title="Success" --text="Created $output_file"
    echo "SUCCESS: Created $output_file" >"$STATUS_FILE"
  else
    debug "Failed to verify $output_file after creation"
    zenity --error --title="Error" --text="Failed to verify $output_file"
    echo "ERROR: Failed to verify $output_file" >"$STATUS_FILE"
    return 1
  fi
}

# Main function
main() {
  setup_template

  local context=$(get_context)
  if [ -z "$context" ]; then
    zenity --error --title="Error" --text="Could not determine working directory"
    echo "ERROR: Could not determine working directory" >"$STATUS_FILE"
    exit 1
  fi

  # Simple Zenity yes/no choice
  debug "Launching Zenity dialog"
  if zenity --question --title="Create README" --text="Create README.md in $context?" 2>/dev/null; then
    debug "User chose to create README"
    create_readme "$context"
  else
    debug "User chose not to create README"
    zenity --info --title="Skipped" --text="No README created."
    echo "SKIPPED: No README created" >"$STATUS_FILE"
  fi

  # Output status for terminal
  cat "$STATUS_FILE"
}

# Run main function
main "$@"
