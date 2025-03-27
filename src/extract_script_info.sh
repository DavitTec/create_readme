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

  while IFS="|" read -r pair; do
    key=$(echo "$pair" | cut -d':' -f1)
    value=$(echo "$pair" | cut -d':' -f2- | tr -d ' ')
    scripts["SCRIPT_${key^^}($index)"]="$value"
  done <<<"$info"

  state=$(echo "$state" | tr -d '\n"')
  local readme_version=$(get_Doc_Version "$readme" "$case_sensitive")
  local dev_doc_version=$(get_Doc_Version "$dev_doc" "$case_sensitive")
  local help_version=$(get_Doc_Version "$docs" "$case_sensitive")

  echo "name:$name|state:$state|version:$version|size:$size|docs:$docs|author:$author|readme:$readme|readme_version:$readme_version|dev_doc:$dev_doc|dev_doc_version:$dev_doc_version|help_version:$help_version|case_notes:$case_notes"
}
