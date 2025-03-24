#!/bin/bash
# update_TODO.sh
# Script to update ToDo.md with script information from ./scripts/ folder

# Configuration
VERSION="0.0.1-1"
SOURCE_DIR="./scripts/test"
DOCS="./docs/test/"
TODO_FILE="$DOCS/ToDo.md"
TEMP_FILE="$DOCS/$TODO_FILE.tmp"

# Check if required directories and files exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Scripts directory not found at $SOURCE_DIR"
    exit 1
fi

echo "Scripts directory found at $SOURCE_DIR"

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
    done <"$file"

    echo "name:$name|state:$state|version:$version|size:$size|docs:$docs|author:$author"
}

get_Docs() {
    err=0
    local file="$1"
    # file=replace ".sh" to ".md" extension
    #  local basename=$(basename "$file")
    local script_file="$1"
    echo "Checking script file $script_file"
    if [[ "${script_file: -2}" != "sh" ]]; then
        echo "~~> ${script_file} is not a script file"
        return 1
    fi

    DOCS_dir=${DOCS%/} #remove backslash
    echo " [0] DOCs Location: $DOCS_dir"
    # Check if required directories and files exist
    if [ ! -d "$DOCS" ]; then
        echo "~~>[0] Error: Docs directory not found at $DOCS_dir"
        err=1
        output="~~> [3] No Help Documentation available"
    fi

    #echo "  [$err] WARNING: DONT HAVE A HELP DIRECTORY we have a problem at [1]"
    # Does main Docs help exisit?
    if [ $err == 0 ]; then
        local HELP_doc="${DOCS%/}/help.md"
        echo -n "~~> [1] Looking for mains help : $HELP_doc"

        if [ -f "$HELP_doc" ]; then
            echo " [1] available"
        else
            msg="~~> [3] No Help Documentation available"
            echo " >>> [error 1] No Help Documentation available"
            err=2
        fi
    fi

    if [ $err == 0 ]; then
        suc=" and you will find $HELP_doc"
        # echo "$suc"
    fi

    echo "~~> [1] Documents are located at $DOCS_dir $suc"
    docs_file="$(basename "$script_file" .sh).md"

    # looking for script help
    echo -n "~~> [2] Looking for $docs_file"

    # target=PATH/file exist?
    if [ ! -f "$DOCS_dir/$docs_file" ]; then
        echo " [2] Error: $docs_file not found at $DOCS_dir"
        output="$HELP_doc"
        echo -n "~~> [3] Other HELP is at $HELP_doc"
    else
        output="$DOCS_dir/$docs_file"
    fi

    echo
    echo -e "~~> [4] RETURN $output [success]\n"
    echo "$output"
}

# Build scripts object (associative array)
declare -A scripts

# Process each script file
index=1
for script_file in "$SOURCE_DIR"/*; do
    if [ -f "$script_file" ]; then
        info=$(extract_script_info "$script_file")
        # TODO test
        echo "DATA_SCRIPTS($index):= $info" #remove after test
        scripts["SCRIPT_NAME($index)"]=$(echo "$info" | cut -d'|' -f1 | cut -d':' -f2)
        scripts["SCRIPT_STATE($index)"]=$(echo "$info" | cut -d'|' -f2 | cut -d':' -f2)
        scripts["VERSION($index)"]=$(echo "$info" | cut -d'|' -f3 | cut -d':' -f2)
        scripts["SCRIPT_LOCATION($index)"]="$script_file"
        get_Docs "test_script.sh"
        scripts["SCRIPT_DOCS($index)"]="" # Add documentation link if available
        scripts["AUTHOR($index)"]=$(echo "$info" | cut -d'|' -f6 | cut -d':' -f2)
        echo ${scripts["AUTHOR($index)"]} #remove after test
        ((index++))
    fi
done

# Update ToDo.md
while IFS= read -r line; do
    new_line="$line"
    # Replace variables with actual values
    for key in "${!scripts[@]}"; do
        if [[ "$new_line" =~ \§"$key" ]]; then
            value="${scripts[$key]}"
            new_line="${new_line//\§$key/$value}"
        fi
    done
    echo "$new_line"
done <"$TODO_FILE" >"$TEMP_FILE"

# Replace original file with updated version
mv "$TEMP_FILE" "$TODO_FILE"

echo "Updated $TODO_FILE successfully"
exit 0
