#!/bin/bash
# update_TODO.sh
VERSION="0.0.5"  # Incremented from 0.0.4 (minor change for template generation)

# Source package.json variables using jq (assuming jq is installed)
if [ -f "package.json" ] && command -v jq >/dev/null 2>&1; then
    PKG_VERSION=$(jq -r '.version' package.json)
    PKG_REPO_URL=$(jq -r '.repository.url' package.json | sed 's/git+//')
    PKG_AUTHOR=$(jq -r '.author' package.json)
else
    echo "Warning: package.json not found or jq not installed. Using .env_test defaults."
fi

# Source environment variables from .env_test (fallback)
if [ -f ".env_test" ]; then
    source .env_test
else
    echo "Error: .env_test file not found"
    exit 1
fi

# Override with package.json values if available
SOURCE_DIR=${SOURCE_DIR:-./scripts}
DOCS_DIR=${DOCS_DIR:-./docs}
TEST_DIR=${TEST_DIR:-./docs/test}
TODO_FILE=${TODO_FILE:-./docs/ToDo.md}
TEST_TODO_FILE=${TEST_TODO_FILE:-./docs/test/ToDo_TEST_.md}  # Changed to ToDo_TEST_.md
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

# Function to extract documentation
get_Docs() {
    local script_file="$1"
    local output=""

    if [[ "${script_file: -3}" != ".sh" ]]; then
        return 1
    fi

    local docs_file="$(basename "$script_file" .sh).md"
    local script_docs="${DOCS_DIR}/${docs_file}"

    if [ -f "$script_docs" ]; then
        output="$script_docs"
    elif [ -f "$DOCS_DIR/help.md" ]; then
        output="$DOCS_DIR/help.md"
    else
        output="$SCRIPT_DOCS_DEFAULT"
    fi

    echo "$output"
}

# Function to extract info from script files
extract_script_info() {
    local file="$1"
    local basename=$(basename "$file")
    local name="${basename}"
    local state="$SCRIPT_STATE_DEFAULT"
    local version="$SCRIPT_VERSION_DEFAULT"
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    local docs=$(get_Docs "$file")
    local author="$SCRIPT_AUTHOR_DEFAULT"

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

    echo "name:$name|state:$state|version:$version|size:$size|docs:$docs|author:$author"
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
        ((index++))
    fi
done

# Generate ToDo_TEST_.md template in test mode
if [ "$MODE" = "test" ]; then
    mkdir -p "$TEST_DIR"
    cat << EOF > "$TARGET_TODO"
# Todo
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

Replace **NAME:** §SCRIPT_NAME($i) with the §SCRIPT_NAME(0)
Replace **STATE:** §SCRIPT_STATE($i) with the §SCRIPT_STATE(0)
Replace **VERSION:** §VERSION($i) with the §VERSION(0)
Replace **LOCATION:** §SCRIPT_LOCATION($i) with the §SCRIPT_LOCATION(0)
Replace **DOCS:** §SCRIPT_DOCS($i) with the §SCRIPT_DOCS(0)
Replace **AUTHOR:** §SCRIPT_AUTHOR($i) with the §SCRIPT_AUTHOR(0)

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