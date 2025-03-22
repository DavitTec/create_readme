# Development

> Create a Markdown README.md and the like for file and project management based from context template(s)

| [HOME](../README.md) | **DEVELOPMENT** | [HELP](./help.md) | [ISSUES](./issues.md) | [ToDo](./ToDo.md) |

## Current Directory Structure

```bash
.
├── CHANGELOG.md
├── docs
│   ├── assets
│   │   └── repository-open-graph-template.png
│   ├── Development.md
│   ├── help.md
│   ├── issues.md
│   └── ToDo.md
├── LICENSE
├── node_modules
│   └── varioius
├── package.json
├── pnpm-lock.yaml
├── public
│   ├── favicon_io
│   │   ├── varioius
│   ├── icons
│   │   └── varioius
│   └── img
│       └── varioius
├── README.md
├── scripts
│   ├── create_readme.sh
│   ├── Insert
│   └── insert_readme.sh
└── src
    └── Templates
        └── README_0.md
```

## Scripts

- [**insert_readme.sh**](../scripts/insert_readme.sh) (Version 0.3)
  - **Purpose**: A simple copy of a [README.md](../src/Templates/README_0.md) template from [Templates](../src/Templates/) into your current folder using a caja scripts-like feature.
  - **Why It’s Useful**: Adds basic README script to [Caja](./docs/help.md#using caja), saving time by avoiding external editors for simple tasks.
  - **Source**: [insert_readme.sh](../scripts/insert_readme.sh)

## Version 006

Let's create an "Insert" script that meets your requirements. Here's a bash script that accomplishes what you've described:

creating a [Insert](../scripts/Insert) script

```bash
#!/bin/bash

# Target directory for CAJA scripts
CAJA_SCRIPTS_DIR="$HOME/.config/caja/scripts"
SOURCE_SCRIPT="./scripts/insert_readme.sh"
TARGET_SCRIPT_NAME="INSERT README"
VERSION="1.0.0"  # You can modify this version number
#....
#.... # OPEN script for more 
```

To implement this, follow these steps:

1. Save this script as `Insert` (without .sh extension) in your `./scripts/` folder

2. Make it executable:
```bash
chmod +x ./scripts/Insert
```

3. Add this to your `package.json` under the "scripts" section:
```json
{
  "scripts": {
    "deploy:caja": "bash ./scripts/Insert"
  }
}
```

This script will:
1. Check if Caja is installed
2. Create the CAJA scripts directory if it doesn't exist
3. Verify the source script exists
4. Check if the script already exists in the target location and compare versions
5. Copy the script with the capitalized name "INSERT README"
6. Make it executable
7. Provide feedback about the installation

To use it:
```bash
npm run deploy:caja
```

The script assumes:
- Your original `insert_readme.sh` exists in `./scripts/`
- You're using Ubuntu 20.04 or later (Caja is typically available)
- You have write permissions in your home directory

If you need to modify the version checking logic or add more features, let me know! You might want to adjust the VERSION variable or add more sophisticated version comparison depending on your needs.

## Version 003

Lets first "create README.md" script better to include a default basic Template and or an option to select different prescribed templates for specific cases, like 

**Options**

1. default template for most project folders fr developing app projects geared for best practice. 
2. template to head a folder that is related to a business development project 
3. a template to head a folder about a person, client, or company 
4. a template for formulating a project plan 
5. a template for starting a screenplay, book, or article 
6. a template for starting an idea 6 - a template for food recipes. (before submitting to my own recipe website 
7. a template for getting a grant on a topic

A README is not usually the first file in a digital collections folder but should be the GUIDE and first to read as to the instructions for managing the Project or Topic folder and its contents.   As I like simple MARKDOWN and TEXT, a system that can quickly cater for handling Refs, footnotes, indexing, and referencing, and simple tables help organise fluid digital content.  All without the headache of formatting or filtering crazy embed content from social media, the web or PDF , documents or giving sources chat rooms like WHATSAPP (which I hate but use far too much) 

Having a quick README.md script to create the required HOW-TO and GUIDE helps according to a particular context and its project 

A 100s ideas person usually working on many simultaneous items (ideas) at the same time. This is why one needs a quick offload of thoughts before returning back to each idea with snapshot of the same thought.  Use README more often.  

Pioneers had RFC (requests for comments) and had a serialise pathway to progress ideas evolution when others are a given the opportunity to contribute 

A quick way to generate README.md files with different templates based on project types, while keeping things simple and markdown-based. As someone juggling hundreds of ideas, you need a system that's fast, organised, and helps you capture thoughts efficiently. Let's build an enhanced version of your script that meets these requirements.

Here's a solution that incorporates template options and keeps things simple yet powerful:

```bash
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
DEST_DIR="${2:-.}"  # Use current directory if no destination specified

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
            echo -e "# Project README\n\nCreated: $DATE\n\n## Purpose\n\n## Tech Stack\n\n## Setup\n\n## Development Notes\n" > "$TEMPLATE_FILE"
            ;;
        1) # Business Development
            echo -e "# Business Development\n\nCreated: $DATE\n\n## Objectives\n\n## Stakeholders\n\n## Timeline\n\n## Resources\n" > "$TEMPLATE_FILE"
            ;;
        2) # Person/Client/Company
            echo -e "# Profile\n\nCreated: $DATE\n\n## Background\n\n## Contact Info\n\n## Key Details\n\n## Notes\n" > "$TEMPLATE_FILE"
            ;;
        3) # Project Plan
            echo -e "# Project Plan\n\nCreated: $DATE\n\n## Goals\n\n## Milestones\n| Date | Task | Status |\n|------|------|--------|\n\n## Resources\n" > "$TEMPLATE_FILE"
            ;;
        4) # Creative Writing
            echo -e "# Creative Work\n\nCreated: $DATE\n\n## Concept\n\n## Outline\n\n## Characters\n\n## Research\n" > "$TEMPLATE_FILE"
            ;;
        5) # Idea Snapshot
            echo -e "# Idea Snapshot\n\nCreated: $DATE\n\n## Concept\n\n## Potential\n\n## Next Steps\n\n## Related Ideas\n" > "$TEMPLATE_FILE"
            ;;
        6) # Recipe
            echo -e "# Recipe\n\nCreated: $DATE\n\n## Ingredients\n\n## Instructions\n\n## Notes\n\n## Source\n" > "$TEMPLATE_FILE"
            ;;
        7) # Grant Proposal
            echo -e "# Grant Proposal\n\nCreated: $DATE\n\n## Purpose\n\n## Budget\n| Item | Cost | Notes |\n|------|------|-------|\n\n## Impact\n" > "$TEMPLATE_FILE"
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
```



## Version 002

If want to improve your Caja scripts,  Here is the basic but an improved version with better functionality, error handling, and comments;

```bash
#!/bin/bash
version=0.2
# Source template file
SRC="/home/david/Templates/markdown/README.md"
# Current date in YYYYMMDD format
DATE=$(date '+%Y%m%d')
# Default output filename
FILE="README.md"

# Check if source template exists
if [ ! -f "$SRC" ]; then
    echo "Error: Template file not found at $SRC"
    exit 1
fi

# If README.md exists, create a dated version instead
if [ -f "$FILE" ]; then
    FILE="${DATE}-README.md"
    echo "Existing README.md found, creating $FILE instead"
else
    echo "Creating new README.md"
fi

# Copy the template and check if the operation was successful
if cp -n "$SRC" "$FILE"; then
    echo "Successfully created $FILE"
else
    echo "Error: Failed to create $FILE"
    exit 1
fi

exit 0
```

Improvements made:

1. Changed #!/bin/sh to #!/bin/bash for better features
2. Added error checking for the source template
3. Improved variable naming (uppercase for clarity)
4. Added better feedback messages
5. Added error handling for the copy operation
6. Added proper exit codes
7. Made the script more robust with quotes around variables

Additional suggestions you might want to add:

1. Add a custom message to the README

```bash
echo "# Project created on $DATE" > "$FILE"
cat "$SRC" >> "$FILE"
```

1. Add a destination folder parameter

```bash
DEST="${1:-.}"  # Use first argument or current directory
FILE="$DEST/README.md"
```

1. Add a backup feature

```bash
if [ -f "$FILE" ]; then
    mv "$FILE" "${FILE}.bak"
fi
```

---



