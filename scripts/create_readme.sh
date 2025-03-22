#!/bin/bash

# create_readme.sh
VERSION="0.0.6-5"
TEMPLATE_DIR="$HOME/Templates/markdown" # Removed trailing slash
REPO_URL="https://github.com/DavitTec/create_readme"
DEFAULT_TEMPLATE="basic"
DEBUG=false # Set to true for debugging
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTDIR="$TEMPLATE_DIR/test"

# Debug function
debug() {
  if [ "$DEBUG" = true ]; then
    echo "DEBUG: $1 (Test dir: $TESTDIR)"
  fi
}

# Ensure Zenity is installed
if ! command -v zenity &>/dev/null; then
  echo "Error: Zenity is required but not installed"
  exit 1
fi

# Function to show help
show_help() {
  zenity --info --title="Create Readme v$VERSION" \
    --text="Create Readme - Version $VERSION\n\nUsage:\n- Run via Caja Scripts\n- Select folder/file first\n- See $REPO_URL for more info"
}

# Function to ensure template directory exists
setup_templates() {
  mkdir -p "$TEMPLATE_DIR"
  if [ ! -f "$TEMPLATE_DIR/$DEFAULT_TEMPLATE.md" ]; then
    echo "# Project Title\n\n## Description\n[Add description]\n\n## Installation\n[Add instructions]\n\n## Version\n$VERSION" >"$TEMPLATE_DIR/$DEFAULT_TEMPLATE.md"
  fi
  if [ "$DEBUG" = true ]; then
    mkdir -p "$TESTDIR"
  fi
}

# Function to get available templates
get_templates() {
  ls "$TEMPLATE_DIR"/*.md 2>/dev/null | xargs -n 1 basename | sed 's/\.md$//' || echo "$DEFAULT_TEMPLATE"
}

# Function to create README
create_readme() {
  local target_dir="$1"
  local template="$2"
  local output_file="$target_dir/README.md"

  debug "Creating README at $output_file with template $template"

  if [ ! -d "$target_dir" ]; then
    zenity --error --title="Error" --text="Target directory $target_dir does not exist"
    return 1
  fi

  if [ -f "$output_file" ]; then
    if ! zenity --question --title="File Exists" --text="$output_file already exists. Overwrite?"; then
      debug "User chose not to overwrite"
      return 1
    fi
  fi

  if [ ! -f "$TEMPLATE_DIR/$template.md" ]; then
    zenity --error --title="Error" --text="Template $template not found in $TEMPLATE_DIR"
    return 1
  fi

  cp "$TEMPLATE_DIR/$template.md" "$output_file" || {
    zenity --error --title="Error" --text="Failed to create $output_file"
    return 1
  }
  chmod 644 "$output_file"
  zenity --info --title="Success" --text="Created $output_file using $template template"
}

# Function to determine context
get_context() {
  local context

  if [ "$DEBUG" = true ]; then
    context="$TESTDIR"
    debug "Debug mode: Using test directory $context"
  else
    if [ -n "$CAJA_SCRIPT_SELECTED_FILE_PATHS" ]; then
      context="${CAJA_SCRIPT_SELECTED_FILE_PATHS%%$'\n'*}"
      debug "Caja context: Selected path is $context"
    else
      context="$PWD"
      debug "No Caja context: Falling back to current directory $context"
    fi
  fi

  if [ -f "$context" ]; then
    context="$(dirname "$context")"
    debug "Selected a file, using parent directory: $context"
  fi

  if [ ! -d "$context" ]; then
    zenity --error --title="Error" --text="Invalid context: $context is not a directory"
    context=""
  fi

  echo "$context"
}

# Main function
main() {
  local context=$(get_context)

  if [ -z "$context" ]; then
    zenity --error --title="Error" --text="Could not determine working directory"
    exit 1
  fi

  debug "Final working directory: $context"

  # Handle command line args
  while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
      show_help
      exit 0
      ;;
    -v | --version)
      zenity --info --title="Version" --text="Version $VERSION"
      exit 0
      ;;
    *)
      shift
      ;;
    esac
  done

  # Setup templates
  setup_templates

  # Get template choice
  local template=$(get_templates | zenity --list \
    --title="Select Template" \
    --text="Choose a template for $context" \
    --column="Template" \
    --default-item="$DEFAULT_TEMPLATE" \
    --width=300 --height=200 2>/dev/null)

  if [ -z "$template" ]; then
    debug "No template selected, exiting"
    exit 0
  fi

  # Create the README
  create_readme "$context" "$template"
}

# Run main function
main "$@"
