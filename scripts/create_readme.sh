#!/bin/bash

# Default template directory
TEMPLATE_DIR="${HOME}/Templates/markdown"
# Ensure template directory exists
mkdir -p "$TEMPLATE_DIR"
# Current date
DATE=$(date '+%Y%m%d')
# Default output file
OUTPUT_FILE="README.md"

# Define template options
declare -A TEMPLATES
TEMPLATES[0]="$TEMPLATE_DIR/default-project.md"
TEMPLATES[1]="$TEMPLATE_DIR/business-dev.md"
TEMPLATES[2]="$TEMPLATE_DIR/person-client.md"
TEMPLATES[3]="$TEMPLATE_DIR/project-plan.md"
TEMPLATES[4]="$TEMPLATE_DIR/creative-writing.md"
TEMPLATES[5]="$TEMPLATE_DIR/idea-snapshot.md"
TEMPLATES[6]="$TEMPLATE_DIR/recipe.md"
TEMPLATES[7]="$TEMPLATE_DIR/grant-proposal.md"

# Default template content if none exists
DEFAULT_TEMPLATE="# Project README\n\nCreated: $DATE\n\n## Overview\n\n## Next Steps\n\n## References\n"

# Function to show usage
show_usage() {
  echo "Usage: $0 [template_number] [optional_destination_folder]"
  echo "Templates:"
  echo "  0 - Default project (app development)"
  echo "  1 - Business development"
  echo "  2 - Person/client/company"
  echo "  3 - Project plan"
  echo "  4 - Creative writing (screenplay/book/article)"
  echo "  5 - Idea snapshot"
  echo "  6 - Food recipe"
  echo "  7 - Grant proposal"
}

# Check for template number argument
if [ $# -lt 1 ]; then
  show_usage
  exit 1
fi

TEMPLATE_NUM="$1"
DEST_DIR="${2:-.}" # Use current directory if no destination specified

# Validate template number
if ! [[ "$TEMPLATE_NUM" =~ ^[0-7]$ ]]; then
  echo "Error: Template number must be 0-7"
  show_usage
  exit 1
fi

# Set output path
OUTPUT_PATH="$DEST_DIR/$OUTPUT_FILE"

# If file exists, create dated version
if [ -f "$OUTPUT_PATH" ]; then
  OUTPUT_PATH="$DEST_DIR/${DATE}-README.md"
  echo "Existing README.md found, creating dated version: ${DATE}-README.md"
fi

# Check if template exists, create it if not
TEMPLATE_FILE="${TEMPLATES[$TEMPLATE_NUM]}"
if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Creating new template: $TEMPLATE_FILE"
  case $TEMPLATE_NUM in
  0) # Default Project
    echo -e "# Project README\n\nCreated: $DATE\n\n## Purpose\n\n## Tech Stack\n\n## Setup\n\n## Development Notes\n" >"$TEMPLATE_FILE"
    ;;
  1) # Business Development
    echo -e "# Business Development\n\nCreated: $DATE\n\n## Objectives\n\n## Stakeholders\n\n## Timeline\n\n## Resources\n" >"$TEMPLATE_FILE"
    ;;
  2) # Person/Client/Company
    echo -e "# Profile\n\nCreated: $DATE\n\n## Background\n\n## Contact Info\n\n## Key Details\n\n## Notes\n" >"$TEMPLATE_FILE"
    ;;
  3) # Project Plan
    echo -e "# Project Plan\n\nCreated: $DATE\n\n## Goals\n\n## Milestones\n| Date | Task | Status |\n|------|------|--------|\n\n## Resources\n" >"$TEMPLATE_FILE"
    ;;
  4) # Creative Writing
    echo -e "# Creative Work\n\nCreated: $DATE\n\n## Concept\n\n## Outline\n\n## Characters\n\n## Research\n" >"$TEMPLATE_FILE"
    ;;
  5) # Idea Snapshot
    echo -e "# Idea Snapshot\n\nCreated: $DATE\n\n## Concept\n\n## Potential\n\n## Next Steps\n\n## Related Ideas\n" >"$TEMPLATE_FILE"
    ;;
  6) # Recipe
    echo -e "# Recipe\n\nCreated: $DATE\n\n## Ingredients\n\n## Instructions\n\n## Notes\n\n## Source\n" >"$TEMPLATE_FILE"
    ;;
  7) # Grant Proposal
    echo -e "# Grant Proposal\n\nCreated: $DATE\n\n## Purpose\n\n## Budget\n| Item | Cost | Notes |\n|------|------|-------|\n\n## Impact\n" >"$TEMPLATE_FILE"
    ;;
  esac
fi

# Create the README from template
if cp "$TEMPLATE_FILE" "$OUTPUT_PATH"; then
  echo "Successfully created: $OUTPUT_PATH"
else
  echo "Error: Failed to create $OUTPUT_PATH"
  exit 1
fi

exit 0
