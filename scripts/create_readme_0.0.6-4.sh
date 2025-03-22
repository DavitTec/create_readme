#!/bin/bash

# create_readme.sh
VERSION="0.0.6-4"
TEMPLATE_DIR="$HOME/Templates/markdown/" # TODO Moving templates to user $HOME/Templates/markdown if exists else create
REPO_URL="https://github.com/DavitTec/create_readme"
DEFAULT_TEMPLATE="basic"
DEBUG=false # Set to true for debugging
# Get script's directory and set TESTDIR relative to it
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # Assume "$HOME/.config/caja/scripts "
# TODO do we need SCRIPT_DIR varable?
# TODO Test direct in DEBUG mode must point to $USER $TEMPLATE_DIR/test and testif exists
TESTDIR="$TEMPLATE_DIR/test"

# Debug function
debug() {
  if [ "$DEBUG" = true ]; then
    echo "DEBUG: $1 : Testing in $TESTDIR directory"
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

# Main function
main() {
  local context

  # Set context based on debug mode
  if [ "$DEBUG" = true ]; then
    context="$TESTDIR"
    debug "Running in debug mode, using test directory: $TESTDIR"
    # Ensure test directory exists
    mkdir -p "$TESTDIR"
  else
    # Get context from Caja
    context="${CAJA_SCRIPT_SELECTED_FILE_PATHS%%$'\n'*}"
    # Fallback to current directory if no selection
    [ -n "$context" ] || context="$PWD"
  fi

  # If it's a file, use its parent directory
  if [ -f "$context" ]; then
    context="$(dirname "$context")"
  fi

  debug "Working directory: $context"

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
    --width=300 --height=200)

  # Cancel if no template selected
  [ -n "$template" ] || {
    debug "No template selected, exiting"
    exit 0
  }

  # Create the README
  create_readme "$context" "$template"
}

# Run main function
main "$@"
