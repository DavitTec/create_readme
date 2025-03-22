#!/bin/bash

# create_readme.sh
VERSION="0.0.6-2"
TEMPLATE_DIR="$HOME/.config/create_readme/templates" # Moving templates to user config
REPO_URL="https://github.com/DavitTec/create_readme"
DEFAULT_TEMPLATE="basic"
DEBUG=true
TESTDIR="../test/" # TODO need to make sure this points relative to the script base folder

# Debug
# TODO Need to redefine the DBUGGING and testing features here
# if debub is set to true then defaults set to test directory
if $DEBUG; then
  echo "DEBUG: Testing in './test/' directory"
  target_dir=$TESTDIR
fi

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
  local target_dir="$1" ||
    local template="$2"
  local output_file="$target_dir/README.md"

  if [ -f "$output_file" ]; then
    if ! zenity --question --title="File Exists" --text="$output_file already exists. Overwrite?"; then
      return 1
    fi
  fi

  cp "$TEMPLATE_DIR/$template.md" "$output_file"
  chmod 644 "$output_file"
  zenity --info --title="Success" --text="Created $output_file using $template template"
}

# Main function
main() {
  # Get context from Caja (selected file/folder)
  # TODO trying to catch if in TESTING mode and to simulate mouse actions
  [ ! $DEBUG ] || local context="$TESTDIR"

  context="${CAJA_SCRIPT_SELECTED_FILE_PATHS%%$'\n'*}"

  # If no selection, use current directory
  if [ -z "$context" ]; then
    context="$PWD"
    [ ! $DEBUG ] || context="$TESTDIR"
  fi

  # If it's a file, use its parent directory
  if [ -f "$context" ]; then
    context="$(dirname "$context")"
  fi

  # Handle command line args for terminal use
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

  # Setup templates if needed
  setup_templates

  # Get template choice with Zenity
  local template=$(get_templates | zenity --list \
    --title="Select Template" \
    --text="Choose a template for $context" \
    --column="Template" \
    --default-item="$DEFAULT_TEMPLATE" \
    --width=300 --height=200)

  # Cancel if no template selected
  if [ -z "$template" ]; then
    exit 0
  fi

  # Create the README
  create_readme "$context" "$template"
}

# Run main function
main "$@"
