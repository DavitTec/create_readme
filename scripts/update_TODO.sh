#!/bin/bash
# update_TODO.sh
VERSION="0.0.11"  # Incremented for modularization and fixes

# Check for jq
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required. Install it (e.g., 'sudo apt install jq')."
    exit 1
fi

# Source external functions
for func in src/*.sh; do
    [ -f "$func" ] && source "$func"
done

# Load settings from package.json
if [ -f "package.json" ]; then
    CASE_SENSITIVE=$(jq -r '.settings.CASE_SENSITIVE // "true"' package.json)
    LOC=$(jq -r '.settings.LOC // "UK"' package.json)
    LANG=$(jq -r '.settings.LANG // "en-GB"' package.json)
    EOL=$(jq -r '.settings.EOL // "LF"' package.json)
    PKG_VERSION=$(jq -r '.version // "unknown"' package.json)
    PKG_REPO_URL=$(jq -r '.repository.url // "unknown" | sub("git\\+"; "")' package.json)
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

# Load config from variables.json
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
        -d|--delete) OPTIONS="$OPTIONS delete"; shift;;
        --fix-case) OPTIONS="$OPTIONS fix-case"; shift;;
        *) echo "Unknown option: $1"; exit 1;;
    esac
done

# Determine mode
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

# Check directories
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Scripts directory not found at $SOURCE_DIR"
    exit 1
fi

# Build scripts object
declare -A scripts
while IFS="=" read -r key value; do
    scripts["SCRIPT_$key(0)"]="$value"
done < <(jq -r '.placeholders | to_entries | .[] | "\(.key)=\(.value.value)"' variables.json)
scripts["SCRIPT_LOCATION(0)"]=$(jq -r '.placeholders.LOCATION.value' variables.json)

index=1
for script_file in "$SOURCE_DIR"/*; do
    if [ -f "$script_file" ]; then
        info=$(extract_script_info "$script_file" "$DOCS_DIR" "$PKG_AUTHOR" "$CASE_SENSITIVE")
        while IFS="|" read -r pair; do
            key=$(echo "$pair" | cut -d':' -f1)
            value=$(echo "$pair" | cut -d':' -f2-)
            scripts["SCRIPT_${key^^}($index)"]="$value"
        done <<< "$info"
        scripts["SCRIPT_LOCATION($index)"]="$script_file"
        ((index++))
    fi
done

# Generate ToDo_TEST_.md
if [ "$MODE" = "test" ]; then
    mkdir -p "$TEST_DIR"
    {
        echo "# Todo"
        echo "## Package Info"
        echo "- Package Version: $PKG_VERSION"
        echo "- Repository: $PKG_REPO_URL"
        echo "- Author: $PKG_AUTHOR"
        echo "- Settings:"
        echo "  - Case Sensitive: $CASE_SENSITIVE"
        echo "  - Localization: $LOC"
        echo "  - Language: $LANG"
        echo "  - Line Ending: $EOL"
        echo ""
        echo "## Tasks"
        echo "object "
        echo "echo"
        jq -r '.placeholders | to_entries | .[] | "\(.value.order) \"\(.key | ascii_downcase):\$\(.key | ascii_downcase)|\""' variables.json | sort -n
        echo ""
        echo "This is a TEST file to check capture and replacement of all variables"
        echo ""
        echo "---- **TEST** ----"
    } > "$TARGET_TODO"

    for i in $(seq 0 $((index-1))); do
        case_notes="${scripts[SCRIPT_CASE_NOTES($i)]}"
        cat << EOF >> "$TARGET_TODO"

### TEST for Script $i
- **NAME**: ${scripts[SCRIPT_NAME($i)]}
- **STATE**: ${scripts[SCRIPT_STATE($i)]}
- **SCRIPT VERSION**: ${scripts[SCRIPT_VERSION($i)]}
- **SIZE**: ${scripts[SCRIPT_SIZE($i)]}
- **DOCS**: ${scripts[SCRIPT_DOCS($i)]}
- **AUTHOR**: ${scripts[SCRIPT_AUTHOR($i)]}
- **README**: ${scripts[SCRIPT_README($i)]}
- **README_VERSION**: ${scripts[SCRIPT_README_VERSION($i)]}
- **DEV_DOC**: ${scripts[SCRIPT_DEV_DOC($i)]}
- **DEV_DOC_VERSION**: ${scripts[SCRIPT_DEV_DOC_VERSION($i)]}
- **HELP_VERSION**: ${scripts[SCRIPT_HELP_VERSION($i)]}
- **LOCATION**: ${scripts[SCRIPT_LOCATION($i)]}
$case_notes

Check format:
  - [ ] develop a [${scripts[SCRIPT_NAME($i)]}](${scripts[SCRIPT_LOCATION($i)]})-${scripts[SCRIPT_VERSION($i)]}([docs](${scripts[SCRIPT_DOCS($i)]})) (${scripts[SCRIPT_STATE($i)]})
EOF
    done
fi

# Handle options
if [[ "$OPTIONS" =~ delete ]] && [ "$MODE" = "test" ]; then
    rm -rf "$TEST_DIR"
    echo "Test directory $TEST_DIR deleted"
fi

echo "Updated $TARGET_TODO successfully"
exit 0