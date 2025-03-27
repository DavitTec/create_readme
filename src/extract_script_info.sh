#!/bin/bash
# extract_script_info.sh
version=0.0.1


extract_script_info() {
  local file="$1"
  local docs_dir="$2"
  local pkg_author="$3"
  local case_sensitive="$4"
  local basename=$(basename "$file")
  local name="$basename"
  local state=$(jq -r '.placeholders.STATE.value' variables.json)
  local version=$(jq -r '.placeholders.VERSION.value' variables.json)
  local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
  local docs="${docs_dir}/${basename%.sh}_help.md"
  local author="$pkg_author"
  local readme="${docs_dir}/${basename%.sh}_Readme.md"
  local dev_doc="${docs_dir}/${basename%.sh}_Developer.md"
  local case_notes=""

  while IFS= read -r line; do
    if [ "$case_sensitive" = "true" ]; then
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
  done <"$file"

  state=$(echo "$state" | tr -d '\n"')
  local readme_version=$(get_Doc_Version "$readme" "$case_sensitive")
  local dev_doc_version=$(get_Doc_Version "$dev_doc" "$case_sensitive")
  local help_version=$(get_Doc_Version "$docs" "$case_sensitive")

  echo "name:$name|state:$state|version:$version|size:$size|docs:$docs|author:$author|readme:$readme|readme_version:$readme_version|dev_doc:$dev_doc|dev_doc_version:$dev_doc_version|help_version:$help_version|case_notes:$case_notes"
}
