#!/bin/bash
# update_TODO.sh
VERSION="0.0.9"  # Incremented from 0.0.8 (case/localization fixes)

# Check for jq (required for JSON parsing)
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required for JSON parsing. Please install it (e.g., 'sudo apt install jq')."
    exit 1
fi

# Load settings from package.json
if [ -f "package.json" ]; then
    CASE_SENSITIVE=$(jq -r '.settings.CASE_SENSITIVE // "true"' package.json)
    LOC=$(jq -r '.settings.LOC // "UK"' package.json)
    LANG=$(jq -r '.settings.LANG // "en-GB"' package.json)
    EOL=$(jq -r '.settings.EOL // "LF"' package.json)
    PKG_VERSION=$(jq -r '.version // "unknown"' package.json)
    PKG_REPO_URL=$(jq -r '.repository.url // "unknown" | sub("git+"; "")' package.json)
    PKG_AUTHOR=$(jq -r '.author // "unknown"' package.json)
else
    echo "Warning: package.json not found. Using defaults."
    CASE_SENSITIVE="true"
    LOC="UK"
    LANG="en-GB"
    EOL="LF"
    PKG_VERSION="unknown"
    PKG_REPO_URL="unknown"
    PKG_AUTHOR="unknown"
fi

# Load variables from variables.json
if [ -f "variables.json" ]; then
    eval "$(jq -r '.config | to_entries | .[] | "export \(.key)=\(.value.value)"' variables.json)"
else
    echo "Error: variables.json not found"
    exit 1
fi

# Parse command-line arguments
OPTIONS=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--delete)
            OPTIONS="$OPTIONS delete"
            shift
            ;;
        --fix-case)
            OPTIONS="$OPTIONS fix-case"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Determine mode (testing or live)
if [ -d "$TEST_DIR" ]; then
    MODE="test"
    TARGET_TODO="$TEST_TODO_FILE"
    TARGET_TEMP="$TEST_TODO_FILE.tmp"
    DOCS_DIR="$TEST_DIR"
    echo "Running in TEST mode: Updating $TARGET_TODO"
else
    MODE="live"
    TARGET_TODO="$TODO_FILE"
    TARGET_TEMP="$TODO_FILE.tmp"
    echo "Running in LIVE mode: Updating $TARGET_TODO"
fi

# Check if required directories exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Scripts directory not found at $SOURCE_DIR"
    exit 1
fi

# Function to normalize case based on CASE_SENSITIVE
normalize_case() {
    local value="$1"
    if [ "$CASE_SENSITIVE" = "false" ]; then
        echo "$value" | tr '[:upper:]' '[:lower:]'
    else
        echo "$value"
    fi
}

# Function to extract documentation version
get_Doc_Version() {
    local doc_file="$1"
    local version="unknown"
    if [ -f "$doc_file" ]; then
        if [ "$CASE_SENSITIVE" = "true" ]; then
            version=$(grep -oP 'Version:\s*\K[0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?' "$doc_file" || echo "unknown")
        else
            version=$(grep -i -oP '[Vv][Ee][Rr][Ss][Ii][Oo][Nn]:\s*\K[0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?' "$doc_file" || echo "unknown")
        fi
    fi
    echo "$version"
}

# Function to extract info from script files
extract_script_info() {
    local file="$1"
    local basename=$(basename "$file")
    local name="$basename"
    local state=$(jq -r '.placeholders.STATE.value' variables.json)
    local version=$(jq -r '.placeholders.VERSION.value' variables.json)
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    local docs="${DOCS_DIR}/${basename%.sh}_help.md"
    local author="$PKG_AUTHOR"
    local readme="${DOCS_DIR}/${basename%.sh}_Readme.md"
    local dev_doc="${DOCS_DIR}/${basename%.sh}_Developer.md"
    local case_notes=""

    # Extract script metadata
    while IFS= read -r line; do
        if [ "$CASE_SENSITIVE" = "true" ]; then
            if [[ "$line" =~ VERSION[[:space:]]*=[[:space:]]*\"?([0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?)\"? ]]; then
                version="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ [Vv][Ee][Rr][Ss][Ii][Oo][Nn][[:space:]]*=[[:space:]]*\"?([0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?)\"? ]]; then
                case_notes="$case_notes TODO: VERSION case mismatch in $file (expected 'VERSION')\n"
            fi
            if [[ "$line" =~ Author:[[:space:]]*(.*) ]]; then
                author="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ [Aa][Uu][Tt][Hh][Oo][Rr]:[[:space:]]*(.*) ]]; then
                case_notes="$case_notes TODO: Author case mismatch in $file (expected 'Author:')\n"
            fi
            if [[ "$line" =~ State:[[:space:]]*(.*) ]]; then
                state="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ [Ss][Tt][Aa][Tt][Ee]:[[:space:]]*(.*) ]]; then
                case_notes="$case_notes TODO: State case mismatch in $file (expected 'State:')\n"
            fi
        else
            if [[ "$line" =~ [Vv][Ee][Rr][Ss][Ii][Oo][Nn][[:space:]]*=[[:space:]]*\"?([0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?)\"? ]]; then
                version="${BASH_REMATCH[1]}"
            fi
            if [[ "$line" =~ [Aa][Uu][Tt][Hh][Oo][Rr]:[[:space:]]*(.*) ]]; then
                author="${BASH_REMATCH[1]}"
            fi
            if [[ "$line" =~ [Ss][Tt][Aa][Tt][Ee]:[[:space:]]*(.*) ]]; then
                state="${BASH_REMATCH[1]}"
            fi
        fi
    done < "$file"

    # Get doc versions
    local readme_version=$(get_Doc_Version "$readme")
    local dev_doc_version=$(get_Doc_Version "$dev_doc")
    local help_version=$(get_Doc_Version "$docs")

    echo "name:$name|state:$state|version:$version|size:$size|docs:$docs|author:$author|readme:$readme|readme_version:$readme_version|dev_doc:$dev_doc|dev_doc_version:$dev_doc_version|help_version:$help_version|case_notes:$case_notes"
}

# Build scripts object dynamically from variables.json placeholders
declare -A scripts

# Load placeholder defaults (index 0)
while IFS="=" read -r key value; do
    scripts["SCRIPT_$key(0)"]="$value"
done < <(jq -r '.placeholders | to_entries | .[] | "\(.key)=\(.value.value)"' variables.json)
scripts["SCRIPT_LOCATION(0)"]=$(jq -r '.placeholders.LOCATION.value' variables.json)

# Process script files starting at index 1
index=1
for script_file in "$SOURCE_DIR"/*; do
    if [ -f "$script_file" ]; then
        info=$(extract_script_info "$script_file")
        while IFS="|" read -r pair; do
            key=$(echo "$pair" | cut -d':' -f1)
            value=$(echo "$pair" | cut -d':' -f2-)
            scripts["SCRIPT_${key^^}($index)"]="$value"
        done <<< "$info"
        scripts["SCRIPT_LOCATION($index)"]="$script_file"
        ((index++))
    fi
done

# Generate ToDo_TEST_.md template in test mode
if [ "$MODE" = "test" ]; then
    mkdir -p "$TEST_DIR"
    cat << EOF > "$TARGET_TODO"
# Todo
## Package Info
- Package Version: $PKG_VERSION
- Repository: $PKG_REPO_URL
- Author: $PKG_AUTHOR
- Settings:
  - Case Sensitive: $CASE_SENSITIVE
  - Localization: $LOC
  - Language: $LANG
  - Line Ending: $EOL

## Tasks
object 
echo
$(jq -r '.placeholders | to_entries | .[] | "\(.value.order) \"\(.key | ascii_downcase):\$\(.key | ascii_downcase)|"' variables.json | sort -n)

This is a TEST file to check capture and replacement of all variables

---- **TEST** ----
EOF

    # Dynamically add test sections for each script
    for i in $(seq 0 $((index-1))); do
        case_notes="${scripts[SCRIPT_CASE_NOTES($i)]}"
        cat << EOF >> "$TARGET_TODO"

### TEST for Script $i
$(jq -r '.placeholders | to_entries | .[] | if .key == "VERSION" then "- **SCRIPT \(.key)**: §SCRIPT_\(.key)($i)" else "- **\(.key)**: §SCRIPT_\(.key)($i)" end' variables.json)
- **LOCATION**: §SCRIPT_LOCATION($i)
$case_notes

Check format: 
  - [ ] develop a [§SCRIPT_NAME($i)](§SCRIPT_LOCATION($i))-§SCRIPT_VERSION($i)([docs](§SCRIPT_DOCS($i))) (§SCRIPT_STATE($i))
EOF
    done
fi

# Update ToDo.md with §VARIABLES
while IFS= read -r line; do
    new_line="$line"
    for key in "${!scripts[@]}"; do
        if [[ "$new_line" =~ §"$key" ]]; then
            value="${scripts[$key]}"
            new_line="${new_line//§$key/$value}"
        fi
    done
    if [ "$EOL" = "CRLF" ]; then
        echo -ne "$new_line\r\n"
    else
        echo "$new_line"
    fi
done < "$TARGET_TODO" > "$TARGET_TEMP"

mv "$TARGET_TEMP" "$TARGET_TODO"

# Handle options
if [[ "$OPTIONS" =~ delete ]] && [ "$MODE" = "test" ]; then
    rm -rf "$TEST_DIR"
    echo "Test directory $TEST_DIR deleted"
fi

echo "Updated $TARGET_TODO successfully"
exit 0