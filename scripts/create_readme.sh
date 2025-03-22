#!/bin/bash

# create_readme.sh
VERSION="0.0.7"
TEMPLATE_DIR="./src/Templates"
OUTPUT_FILE="README.md"

# Help message
show_help() {
  echo "Create Readme - Version $VERSION"
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -h, --help     Show this help message"
  echo "  -v, --version  Show version"
  echo "  -t, --template Specify template name (default: basic)"
  echo "  -o, --output   Specify output file (default: README.md)"
}

# Default template
TEMPLATE="basic"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --help)
    show_help
    exit 0
    ;;
  -v | --version)
    echo "Version $VERSION"
    exit 0
    ;;
  -t | --template)
    TEMPLATE="$2"
    shift 2
    ;;
  -o | --output)
    OUTPUT_FILE="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
  esac
done

# Check if template exists
TEMPLATE_FILE="$TEMPLATE_DIR/$TEMPLATE.md"
if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Error: Template '$TEMPLATE' not found in $TEMPLATE_DIR"
  exit 1
fi

# Create README from template
if [ -f "$OUTPUT_FILE" ]; then
  echo "Warning: $OUTPUT_FILE already exists. Overwriting..."
fi

cp "$TEMPLATE_FILE" "$OUTPUT_FILE"
echo "Created $OUTPUT_FILE using $TEMPLATE template"
chmod +644 "$OUTPUT_FILE"

exit 0
