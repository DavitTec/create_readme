# Development

> Create a Markdown README.md and the like for file and project management based from context template(s)

| [HOME](../README.md) | **DEVELOPMENT** | [HELP](./help.md) | [ISSUES](./issues.md) | [ToDo](./ToDo.md) |

## Current Directory Structure

```bash
.
├── CHANGELOG.md
├── docs
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

---

## Version 007

### Background

​	As we were developing together "create_readme" script for CAJA scripts as its not located on https://github.com/DavitTec/create_readme  I need to develop a INSERT script and more 

- [x] As we were developing together "create_readme" script for CAJA scripts.   
- [x] The code of "create_readme.sh" that GROK previously provided did not work and needs some more amendments.    But my simple original script; "insert_readme.sh" does work.   
  1. I want an insert bash script ("Insert" ) [without extension ".sh") in the folder "./scripts/"  to push the  "insert_readme.sh" into the user CAJA scripts folder if is installed CAJA (assume >upbutu 20.0) and  
  2. to check and compare the current script version in the destination, if exists;  
  3. to it executable new script executable;  
  4. remove the extension and Capitalise the script name as "INSERT README" so it is cleaner for the menu, upon activating the Caja Scripts option (left mouse)  
  5. to add another to the "Package.json" action script, to run the "Insert" script, as to deploy.

Let's restructure and fix the "create_readme.sh" script according to your requirements. I'll create a solution that integrates with the Insert script and adds template management.

Here's the updated structure and scripts:

1. First, the main `create_readme.sh` script:

   See 

   [create_readme.sh](../src/create_readme.sh)

2. Create a basic template in `./src/Templates/basic.md`:

​	See

​	[basic.md](../src/Templates/basic.md)

3. Modify the `Insert` script to handle both scripts:

​	See [../scripts/Insert](../scripts/Insert)

### Usage:

- Run `npm run deploy:caja` to install both scripts to Caja
- Right-click in Caja to see "CREATE README" and "INSERT README" in the scripts menu
- The "CREATE README" script will:
  - Create a README.md in the current directory
  - Use the basic template by default
  - Support `-t` flag for different templates
  - Maintain help and version options

The template system allows you to:
- Add more templates to `./src/Templates/` as `.md` files
- Use them with `-t templatename` (without .md extension)
- Later extend the script to create new templates dynamically

This maintains your versioning and help requirements while adding the template system and proper Caja integration through the Insert script. Let me know if you need any adjustments!

To deploy and test

```bash
pnpm deploy:caja
```

### FIX

take note: we are at prerelease 
DavitTec https://github.com/DavitTec/create_readme
chore(release): 0.0.6-1

[./scripts/create_readme.sh](./scripts/create_readme.sh) does not work and assumes running via CAJA scripts "CREATE README" and "INSERT README" from Terminal.Does not work as it is assuming running "CREATE README" and "INSERT README" from Terminal.

- Zenity is a handy tool for creating graphical user interfaces (GUIs) in shell scripts on Linux and Unix-like systems.

1) can we fix the current version to include Zenity and 
2) **Modularity**: Organized into functions for better maintenance
3) less mouse clicks to keep it simple, adopting a default
4) understanding context of left mouse click selection on current folder name or file

### Updates and Fixes:

1. **Zenity Integration**:
   - Uses Zenity for GUI dialogs (template selection, overwrite confirmation, success messages)
   - Reduces mouse clicks by providing a default template and simple selection

2. **Modularity**:
   - Organized into functions: `show_help`, `setup_templates`, `get_templates`, `create_readme`, `main`
   - Easier to maintain and extend

3. **Simplicity**:
   - Automatically uses the selected folder/file context from Caja
   - Defaults to "basic" template
   - Single dialog for template selection

4. **Context Awareness**:
   - Uses `CAJA_SCRIPT_SELECTED_FILE_PATHS` to get the selected item
   - Falls back to current directory if no selection
   - Uses parent directory if a file is selected

### Setup Instructions:

1. Update the script in `./scripts/create_readme.sh`

2. Ensure the `Insert` script from previous responses is updated with the new version:

   ```bash
   # In Insert script, update VERSION
   VERSION="0.0.6-1"
   ```

3. Deploy:

   ```bash
   npm run deploy:caja
   ```

4. Template Management:

   - Templates are now stored in `$HOME/.config/create_readme/templates/`
   - A basic template is created automatically if none exist



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

1. Make it executable:

    ```bash
    chmod +x ./scripts/Insert
    ```

1. Add this to your `package.json` under the "scripts" section:

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

### Options

  1. default template for most project folders fr developing app projects geared for best practice.
  1. template to head a folder that is related to a business development project
  1. a template to head a folder about a person, client, or company
  1. a template for formulating a project plan
  1. a template for starting a screenplay, book, or article
  1. a template for starting an idea 6 - a template for food recipes. (before submitting to my own recipe website
  1. a template for getting a grant on a topic

A README is not usually the first file in a digital collections folder but should be the GUIDE and first to read as to the instructions for managing the Project or Topic folder and its contents. As I like simple MARKDOWN and TEXT, a system that can quickly cater for handling Refs, footnotes, indexing, and referencing, and simple tables help organise fluid digital content. All without the headache of formatting or filtering crazy embed content from social media, the web or PDF , documents or giving sources chat rooms like WHATSAPP (which I hate but use far too much)

Having a quick README.md script to create the required HOW-TO and GUIDE helps according to a particular context and its project

A 100s ideas person usually working on many simultaneous items (ideas) at the same time. This is why one needs a quick offload of thoughts before returning back to each idea with snapshot of the same thought. Use README more often.

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

If want to improve your Caja scripts, Here is the basic but an improved version with better functionality, error handling, and comments;

```bash
#!/bin/bash
VERSION=0.2
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
