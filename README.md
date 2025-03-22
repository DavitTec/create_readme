# Create Readme

🔥 Script and templates to help you Create README.md's.

Version 0.0.2

## Purpose

Generate structured READMEs for any adventure—code, clay houses, or fruit trees.

Built by DAVIT, pioneers of digital validation and heritage preservation, with the help of others, including [GROK](https://x.ai/)

## Tech Stack

- Bash
- Markdown

## Setup

```bash
chmod +x ./insert_readme.sh

```

---

## Development Notes

### Scripts

- [**insert_readme.sh**](./scripts/insert_readme.sh)

  - **Purpose**:
  - **Source**:

  - **Script Example**:

- [Insert_Readme_v.02](./src/Templates/README_template.md)

  - **Purpose**: Basic create README.md file in the current selected folder

  - **Why It’s Useful**: Adds basic README script to [Caja](./docs/help.md#using caja), saving time by avoiding external editors for simple tasks.

  - **Source**:

    ```bash
    # README

    > Summary

    [Back](Back)
    ---
    ## Installation

    ```

  - **Script Example**:

    ```bash
    #!/bin/bash
    version=0.2
    
    # Source template file
    SRC="../src/Templates/README.md"
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
        echo "[v$version] Creating new README.md"
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

-

## Licence

See [MIT](./LICENSE)

## References

See [HELP](docs/help.md)
See [ISSUES](docs/issues.md)
See [ToDo](docs/ToDo.md)
