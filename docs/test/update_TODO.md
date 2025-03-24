# update_TODO.sh


A script to update

>
> I want to design a bash script, named: "update_TODO.sh" (VERSION 0.0.1) , to update variables, like;"$SCRIPT_NAME()",
> "$SCRIPT_DOCS()", 
> "$SCRIPT_VERSION()" ,
> "$SCRIPT_STATE()"from reading the Variables inside the script files in the current source folder "./scripts/*",
> building an update object, "scripts", to include name, state, version, size, docs, author, and update  "ToDo.md" accordingly,
> to replace any Variable with ToDo.md"  tex, marked with an appropriate VARIABLE marker.

Let's create a bash script update_TODO.sh that updates the ToDo.md file by extracting variables from script files and replacing the placeholders. Here's a solution:

bash

```bash
#!/bin/bash

# update_TODO.sh (VERSION 0.0.1)
# Script to update ToDo.md with script information from ./scripts/ folder

# Configuration
VERSION="0.0.1"
SOURCE_DIR="./scripts"
TODO_FILE="./docs/ToDo.md"
TEMP_FILE="./docs/ToDo.md.tmp"

# Check if required directories and files exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Scripts directory not found at $SOURCE_DIR"
    exit 1
fi

if [ ! -f "$TODO_FILE" ]; then
    echo "Error: ToDo.md not found at $TODO_FILE"
    exit 1
fi

# Function to extract info from script files
extract_script_info() {
    local file="$1"
    local basename=$(basename "$file")
    local name="${basename}"
    local state="unknown"
    local version="0.0.0"
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    local docs=""
    local author="unknown"

    # Read file content and extract information
    while IFS= read -r line; do
        # Extract version
        if [[ "$line" =~ VERSION[[:space:]]*=[[:space:]]*\"?([0-9]+\.[0-9]+\.[0-9]+)\"? ]]; then
            version="${BASH_REMATCH[1]}"
        fi
        # Extract author
        if [[ "$line" =~ Author:[[:space:]]*(.*) ]]; then
            author="${BASH_REMATCH[1]}"
        fi
        # Extract state (assuming it might be in a comment)
        if [[ "$line" =~ State:[[:space:]]*(.*) ]]; then
            state="${BASH_REMATCH[1]}"
        fi
    done < "$file"

    echo "name:$name|state:$state|version:$version|size:$size|docs:$docs|author:$author"
}

# Build scripts object (associative array)
declare -A scripts

# Process each script file
index=1
for script_file in "$SOURCE_DIR"/*; do
    if [ -f "$script_file" ]; then
        info=$(extract_script_info "$script_file")
        scripts["SCRIPT_NAME($index)"]=$(echo "$info" | cut -d'|' -f1 | cut -d':' -f2)
        scripts["SCRIPT_STATE($index)"]=$(echo "$info" | cut -d'|' -f2 | cut -d':' -f2)
        scripts["VERSION($index)"]=$(echo "$info" | cut -d'|' -f3 | cut -d':' -f2)
        scripts["SCRIPT_LOCATION($index)"]="$script_file"
        scripts["SCRIPT_DOCS($index)"]=""  # Add documentation link if available
        ((index++))
    fi
done

# Update ToDo.md
while IFS= read -r line; do
    new_line="$line"
    # Replace variables with actual values
    for key in "${!scripts[@]}"; do
        if [[ "$new_line" =~ \$"$key" ]]; then
            value="${scripts[$key]}"
            new_line="${new_line//\$$key/$value}"
        fi
    done
    echo "$new_line"
done < "$TODO_FILE" > "$TEMP_FILE"

# Replace original file with updated version
mv "$TEMP_FILE" "$TODO_FILE"

echo "Updated $TODO_FILE successfully"
exit 0
```

This script does the following:

1. **Setup:**
   - Defines basic variables for version, source directory, and ToDo file location
   - Checks if required directories and files exist
2. **extract_script_info function:**
   - Takes a script file as input
   - Extracts information like:
     - name (filename)
     - state (defaults to "unknown", looks for "State:" in comments)
     - version (looks for VERSION= assignment)
     - size (file size in bytes)
     - docs (empty by default, can be enhanced)
     - author (looks for "Author:" in comments)
3. **Main Logic:**
   - Creates an associative array scripts to store the information
   - Processes each file in ./scripts/
   - Assigns values to corresponding variables with index numbers
   - Updates the ToDo.md file by replacing variables with actual values

To use this script:

1. Save it as update_TODO.sh in your project root
2. Make it executable:

bash

```bash
chmod +x update_TODO.sh
```

1. Run it:

bash

```bash
./update_TODO.sh
```

For it to work properly with your script files, they should contain some metadata like:

bash

```bash
#!/bin/bash
# Author: John Doe
# State: development
VERSION="1.2.3"
# ... rest of the script ...
```

The script will:

- Replace $SCRIPT_NAME(n) with the filename
- Replace $SCRIPT_STATE(n) with the state (or "unknown")
- Replace $VERSION(n) with the version number
- Replace $SCRIPT_LOCATION(n) with the file path
- Replace $SCRIPT_DOCS(n) with documentation link (currently empty)

You might want to enhance it by:

1. Adding error handling for specific cases
2. Implementing a documentation link system
3. Adding more metadata fields
4. Adding validation for version numbers
5. Adding a backup system before overwriting ToDo.md

Would you like me to modify any specific part or add more features?

----

## fix and improve the get_Docs() function

Let's fix and improve the get_Docs() function to handle your test cases properly. Here's the revised version with better logic flow and error handling:

bash

```bash
get_Docs() {
    local err=0
    local script_file="$1"
    local output=""

    # Validate input is a .sh file
    if [[ "${script_file: -3}" != ".sh" ]]; then
        echo "~~> Error: '${script_file}' is not a script file (must end in .sh)"
        return 1
    fi

    echo "Checking script file: $script_file"
    DOCS_dir="${DOCS%/}"  # Remove trailing slash if present
    echo " [0] Docs Location: $DOCS_dir"

    # Check if docs directory exists
    if [ ! -d "$DOCS_dir" ]; then
        echo "~~> [0] Error: Docs directory not found at $DOCS_dir"
        echo "~~> [3] No Help Documentation available"
        return 2
    }

    # Check for main help documentation
    local HELP_doc="${DOCS_dir}/help.md"
    echo -n "~~> [1] Looking for main help: $HELP_doc"
    
    if [ -f "$HELP_doc" ]; then
        echo " [1] available"
    else
        echo " [1] not found"
        err=1
    fi

    # Check for script-specific documentation
    local docs_file="$(basename "$script_file" .sh).md"
    local script_docs="${DOCS_dir}/${docs_file}"
    
    echo -n "~~> [2] Looking for script help: $script_docs"
    
    if [ -f "$script_docs" ]; then
        echo " [2] found"
        output="$script_docs"
    else
        echo " [2] not found"
        if [ $err -eq 1 ]; then
            output="~~> [3] No Help Documentation available"
            err=2
        else
            output="$HELP_doc"
        fi
    fi

    echo
    if [ $err -eq 0 ]; then
        echo -e "~~> [4] RETURN $output [success]\n"
    else
        echo -e "~~> [4] RETURN $output [error $err]\n"
    fi
    
    echo "$output"
    return $err
}
```

Let's test it with your test cases:

Setup for Testing:

bash

```bash
DOCS="./docs/test/"
# Create test directory structure
mkdir -p ./scripts/test ./docs/test
touch ./scripts/test_script.sh
```

Test Case 1: ./scripts/test/help.md exists

bash

```bash
touch ./docs/test/help.md
get_Docs "test_script.sh"
```

Expected Output:

```text
Checking script file: test_script.sh
 [0] Docs Location: ./docs/test
~~> [1] Looking for main help: ./docs/test/help.md [1] available
~~> [2] Looking for script help: ./docs/test/test_script.md [2] not found

~~> [4] RETURN ./docs/test/help.md [success]

./docs/test/help.md
```

Test Case 2: ./scripts/test/help.md doesn't exist

bash

```bash
rm ./docs/test/help.md
get_Docs "test_script.sh"
```

Expected Output:

```text
Checking script file: test_script.sh
 [0] Docs Location: ./docs/test
~~> [1] Looking for main help: ./docs/test/help.md [1] not found
~~> [2] Looking for script help: ./docs/test/test_script.md [2] not found

~~> [4] RETURN ~~> [3] No Help Documentation available [error 2]

~~> [3] No Help Documentation available
```

Test Case 3: Both ./scripts/test/help.md and ./scripts/test_script.sh exist

bash

```bash
touch ./docs/test/help.md
touch ./docs/test/test_script.md
get_Docs "test_script.sh"
```

Expected Output:

```text
Checking script file: test_script.sh
 [0] Docs Location: ./docs/test
~~> [1] Looking for main help: ./docs/test/help.md [1] available
~~> [2] Looking for script help: ./docs/test/test_script.md [2] found

~~> [4] RETURN ./docs/test/test_script.md [success]

./docs/test/test_script.md
```

Improvements Made:

1. **Better Input Validation**: Checks for .sh extension properly
2. **Clearer Logic Flow**: Separates main help and script-specific help checks
3. **Consistent Output**: Returns script-specific docs if available, falls back to main help, or error message
4. **Error Handling**: Uses return codes (0=success, 1=invalid input, 2=no docs)
5. **Path Handling**: Properly handles the DOCS directory path
6. **Output Formatting**: Consistent and informative messaging

Notes:

- The function assumes DOCS is set in the environment before calling
- Returns the path as a string, which can be captured: result=$(get_Docs "test_script.sh")
- You might want to adjust the error messages or add more test cases depending on your needs

Would you like me to modify anything specific for your use case?
