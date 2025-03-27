#!/bin/bash
# update_TODO.sh
VERSION="0.0.7"  # Incremented from 0.0.6 (minor change for test subfolder support)

# Source package.json variables using grep/sed (no jq dependency)
if [ -f "package.json" ]; then
    PKG_VERSION=$(grep -oP '"version":\s*"\K[^"]+' package.json || echo "unknown")
    PKG_REPO_URL=$(grep -oP '"repository":\s*{\s*"type":\s*"git",\s*"url":\s*"\K[^"]+' package.json | sed 's/git+//')
    PKG_AUTHOR=$(grep -oP '"author":\s*"\K[^"]+' package.json || echo "unknown")
else
    echo "Warning: package.json not found. Using .env_test defaults."
fi

# Source environment variables from .env_test (fallback)
if [ -f ".env_test" ]; then
    source .env_test
else
    echo "Error: .env_test file not found"
    exit 1
fi

# Override with package.json values if available, but keep distinct
SOURCE_DIR=${SOURCE_DIR:-./scripts}
DOCS_DIR=${DOCS_DIR:-./docs}
TEST_DIR=${TEST_DIR:-./docs/test}
TODO_FILE=${TODO_FILE:-./docs/ToDo.md}
TEST_TODO_FILE=${TEST_TODO_FILE:-./docs/test/ToDo_TEST_.md}
PKG_VERSION=${PKG_VERSION:-$SCRIPT_VERSION_DEFAULT}
PKG_REPO_URL=${PKG_REPO_URL:-$REPO_URL}
PKG_AUTHOR=${PKG_AUTHOR:-$SCRIPT_AUTHOR_DEFAULT}

# Parse command-line arguments
OPTIONS=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--delete)
            OPTIONS="$OPTIONS delete"
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
    DOCS_DIR="$TEST_DIR"  # Use test subfolder for docs in test mode
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

# Function to extract documentation version (if present)
get_Doc_Version() {
    local doc_file="$1"
    local version="unknown"
    if [ -f "$doc_file" ]; then
        version=$(grep -oP 'Version:\s*\K[0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?' "$doc_file" || echo "unknown")
    fi
    echo "$version"
}

# Function to extract info from script files
extract_script_info() {
    local file="$1"
    local basename=$(basename "$file")
    local name="${basename}"
    local state="$SCRIPT_STATE_DEFAULT"
    local version="$SCRIPT_VERSION_DEFAULT"
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    local docs="${DOCS_DIR}/${basename%.sh}_help.md"  # Use DOCS_DIR dynamically
    local author="$SCRIPT_AUTHOR_DEFAULT"
    local readme="${DOCS_DIR}/${basename%.sh}_Readme.md"
    local dev_doc="${DOCS_DIR}/${basename%.sh}_Developer.md"

    # Extract script metadata
    while IFS= read -r line; do
        if [[ "$line" =~ VERSION[[:space:]]*=[[:space:]]*\"?([0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?)\"? ]]; then
            version="${BASH_REMATCH[1]}"
        fi
        if [[ "$line" =~ Author:[[:space:]]*(.*) ]]; then
            author="${BASH_REMATCH[1]}"
        fi
        if [[ "$line" =~ State:[[:space:]]*(.*) ]]; then
            state="${BASH_REMATCH[1]}"
        fi
    done < "$file"

    # Get doc versions
    local readme_version=$(get_Doc_Version "$readme")
    local dev_doc_version=$(get_Doc_Version "$dev_doc")
    local help_version=$(get_Doc_Version "$docs")

    echo "name:$name|state:$state|version:$version|size:$size|docs:$docs|author:$author|readme:$readme|readme_version:$readme_version|dev_doc:$dev_doc|dev_doc_version:$dev_doc_version|help_version:$help_version"
}

# Build scripts object (associative array)
declare -A scripts

# Index 0 defaults (no script)
scripts["SCRIPT_NAME(0)"]="$SCRIPT_NAME_DEFAULT"
scripts["SCRIPT_STATE(0)"]="$SCRIPT_STATE_DEFAULT"
scripts["VERSION(0)"]="$SCRIPT_VERSION_DEFAULT"
scripts["SCRIPT_LOCATION(0)"]="$SCRIPT_LOCATION_DEFAULT"
scripts["SCRIPT_DOCS(0)"]="$SCRIPT_DOCS_DEFAULT"
scripts["SCRIPT_AUTHOR(0)"]="$SCRIPT_AUTHOR_DEFAULT"
scripts["SCRIPT_README(0)"]="$SCRIPT_README_DEFAULT"
scripts["SCRIPT_README_VERSION(0)"]="$SCRIPT_README_VERSION_DEFAULT"
scripts["SCRIPT_DEV_DOC(0)"]="$SCRIPT_DEV_DOC_DEFAULT"
scripts["SCRIPT_DEV_DOC_VERSION(0)"]="$SCRIPT_DEV_DOC_VERSION_DEFAULT"
scripts["SCRIPT_HELP_VERSION(0)"]="$SCRIPT_HELP_VERSION_DEFAULT"

# Process script files starting at index 1
index=1
for script_file in "$SOURCE_DIR"/*; do
    if [ -f "$script_file" ]; then
        info=$(extract_script_info "$script_file")
        scripts["SCRIPT_NAME($index)"]=$(echo "$info" | cut -d'|' -f1 | cut -d':' -f2)
        scripts["SCRIPT_STATE($index)"]=$(echo "$info" | cut -d'|' -f2 | cut -d':' -f2)
        scripts["VERSION($index)"]=$(echo "$info" | cut -d'|' -f3 | cut -d':' -f2)
        scripts["SCRIPT_LOCATION($index)"]="$script_file"
        scripts["SCRIPT_DOCS($index)"]=$(echo "$info" | cut -d'|' -f5 | cut -d':' -f2)
        scripts["SCRIPT_AUTHOR($index)"]=$(echo "$info" | cut -d'|' -f6 | cut -d':' -f2)
        scripts["SCRIPT_README($index)"]=$(echo "$info" | cut -d'|' -f7 | cut -d':' -f2)
        scripts["SCRIPT_README_VERSION($index)"]=$(echo "$info" | cut -d'|' -f8 | cut -d':' -f2)
        scripts["SCRIPT_DEV_DOC($index)"]=$(echo "$info" | cut -d'|' -f9 | cut -d':' -f2)
        scripts["SCRIPT_DEV_DOC_VERSION($index)"]=$(echo "$info" | cut -d'|' -f10 | cut -d':' -f2)
        scripts["SCRIPT_HELP_VERSION($index)"]=$(echo "$info" | cut -d'|' -f11 | cut -d':' -f2)
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

## Tasks
object 
echo
1 "name:\$name|
2 state:\$state|
3 version:\$version|
4 size:\$size|
5 docs:\$docs|
6 author:\$author"

This is a TEST file to check capture and replacement of all variables

---- **TEST** ----
EOF

    # Dynamically add test sections for each script (including index 0)
    for i in $(seq 0 $((index-1))); do
        cat << EOF >> "$TARGET_TODO"

### TEST for Script $i

- **NAME:** §SCRIPT_NAME($i)
- **STATE:** §SCRIPT_STATE($i)
- **SCRIPT VERSION:** §VERSION($i)
- **LOCATION:** §SCRIPT_LOCATION($i)
- **DOCS (Help):** §SCRIPT_DOCS($i) (Version: §SCRIPT_HELP_VERSION($i))
- **README:** §SCRIPT_README($i) (Version: §SCRIPT_README_VERSION($i))
- **DEV DOC:** §SCRIPT_DEV_DOC($i) (Version: §SCRIPT_DEV_DOC_VERSION($i))
- **AUTHOR:** §SCRIPT_AUTHOR($i)

Check format: 
  - [ ] develop a [§SCRIPT_NAME($i)](§SCRIPT_LOCATION($i))-§VERSION($i)([docs](§SCRIPT_DOCS($i))) (§SCRIPT_STATE($i))
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
    echo "$new_line"
done < "$TARGET_TODO" > "$TARGET_TEMP"

mv "$TARGET_TEMP" "$TARGET_TODO"

# Handle options
if [[ "$OPTIONS" =~ delete ]] && [ "$MODE" = "test" ]; then
    rm -rf "$TEST_DIR"
    echo "Test directory $TEST_DIR deleted"
fi

echo "Updated $TARGET_TODO successfully"
exit 0