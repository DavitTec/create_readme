#!/bin/bash

# create_readme.sh
VERSION="0.0.6-14"
TEMPLATE_DIR="$HOME/Templates/markdown"
REPO_URL="https://github.com/DavitTec/create_readme"
DEFAULT_TEMPLATE="basic"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTDIR="$TEMPLATE_DIR/test"
DEBUG=false

# Debug function (output to stderr)
debug() {
  if [ "$DEBUG" = true ]; then
    echo "DEBUG: $1 (Test dir: $TESTDIR)" >&2
  fi
}

# Diagnostic function
diag() {
  if [ "$DEBUG" = true ]; then
    echo "DIAG: $1" >&2
  fi
}

# Ensure Zenity is installed
if ! command -v zenity &>/dev/null; then
  echo "Error: Zenity is required but not installed" >&2
  exit 1
fi

# Test Zenity functionality (simple list)
test_zenity() {
  zenity --list --title="Test Zenity" --column="Options" --text="This is a Zenity test" "basic" "test" 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Error: Zenity test failed. Please check Zenity installation." >&2
    exit 1
  fi
}

# Function to show help
show_help() {
  zenity --info --title="Create Readme v$VERSION" \
    --text="Create Readme - Version $VERSION\n\nUsage:\n  $0 [options]\n\nOptions:\n  -h, --help     Show this help\n  -v, --version  Show version\n  -d             Enable debug mode (uses $TESTDIR)"
}

# Function to ensure template and test directories exist
setup_templates() {
  mkdir -p "$TEMPLATE_DIR" || {
    zenity --error --title="Error" --text="Failed to create template directory $TEMPLATE_DIR"
    exit 1
  }
  if [ ! -f "$TEMPLATE_DIR/$DEFAULT_TEMPLATE.md" ]; then
    cat <<EOF >"$TEMPLATE_DIR/$DEFAULT_TEMPLATE.md"
# Project Title

## Description
[Add description]

## Installation
[Add instructions]

## Version
$VERSION
EOF
  fi
  if [ "$DEBUG" = true ]; then
    mkdir -p "$TESTDIR" || {
      zenity --error --title="Error" --text="Failed to create test directory $TESTDIR"
      exit 1
    }
    debug "Ensured test directory $TESTDIR exists"
  fi
}

# Function to get available templates
get_templates() {
  local templates=$(ls "$TEMPLATE_DIR"/*.md 2>/dev/null | xargs -n 1 basename | sed 's/\.md$//')
  if [ -z "$templates" ]; then
    echo "$DEFAULT_TEMPLATE"
  else
    echo "$templates"
  fi
}

# Function to create README
create_readme() {
  local target_dir="$1"
  local template="$2"
  local output_file="$target_dir/README.md"

  debug "Creating README at $output_file with template $template"
  diag "Attempting to create $output_file"

  if [ ! -d "$target_dir" ]; then
    diag "Target directory $target_dir does not exist"
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

  # Post-creation check
  if [ -f "$output_file" ]; then
    debug "README created successfully at $output_file"
    zenity --info --title="Success" --text="Created $output_file using $template template"
  else
    zenity --error --title="Error" --text="Failed to verify $output_file after creation"
    return 1
  fi
}

# Function to determine context
get_context() {
  local context

  # Ensure directories are set up
  setup_templates

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
    debug "Selected a file, using parent directory $context"
  fi

  if [ ! -d "$context" ]; then
    debug "Invalid context: $context is not a directory"
    context=""
  fi

  diag "Determined context: $context"
  echo "$context"
}

# Main function
main() {
  # Handle command line args first
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
    -d)
      DEBUG=true
      shift
      ;;
    *)
      shift
      ;;
    esac
  done

  # Test Zenity
  test_zenity

  local context=$(get_context)

  if [ -z "$context" ]; then
    zenity --error --title="Error" --text="Could not determine working directory"
    exit 1
  fi

  diag "Working directory set to: $context"

  # Get template choice
  debug "Fetching templates"
  local templates=$(get_templates)
  if [ -z "$templates" ]; then
    zenity --error --title="Error" --text="No templates found in $TEMPLATE_DIR"
    exit 1
  fi

  debug "Templates available: $templates"
  debug "Launching Zenity dialog"

  # Pass templates as arguments to Zenity
  local template
  template=$(zenity --list \
    --title="Select Template" \
    --text="Choose a template for $context" \
    --column="Template" \
    --default-item="$DEFAULT_TEMPLATE" \
    --width=300 --height=200 \
    --timeout=30 \
    $templates 2>/dev/null)

  if [ $? -ne 0 ]; then
    debug "Zenity dialog failed, timed out, or was cancelled"
    if [ "$DEBUG" = true ]; then
      template="$DEFAULT_TEMPLATE"
      debug "Falling back to default template: $template"
    else
      exit 1
    fi
  elif [ -z "$template" ]; then
    debug "No template selected"
    if [ "$DEBUG" = true ]; then
      template="$DEFAULT_TEMPLATE"
      debug "Falling back to default template: $template"
    else
      exit 0
    fi
  fi

  debug "Selected template: $template"
  # Create the README
  create_readme "$context" "$template"
}

# Run main function
main "$@"
