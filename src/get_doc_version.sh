#!/bin/bash
# get_doc_version.sh
version=0.0.1
get_Doc_Version() {
  local doc_file="$1"
  local case_sensitive="$2"
  local version="unknown"
  if [ -f "$doc_file" ]; then
    if [ "$case_sensitive" = "true" ]; then
      version=$(grep -oP 'Version:\s*\K[0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?' "$doc_file" || echo "unknown")
    else
      version=$(grep -i -oP '[Vv][Ee][Rr][Ss][Ii][Oo][Nn]:\s*\K[0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?' "$doc_file" || echo "unknown")
    fi
  fi
  echo "$version"
}
