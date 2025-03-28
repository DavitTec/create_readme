#!/bin/bash

# test_zenity.sh
VERSION="0.0.1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Debug function
debug() {
  echo "DEBUG: $1" >&2
}

# Ensure Zenity is installed
if ! command -v zenity &>/dev/null; then
  echo "Error: Zenity is required but not installed" >&2
  exit 1
fi

# Simple Zenity test with choices
debug "Launching Zenity dialog"
choice=$(zenity --list \
  --title="Test Zenity" \
  --text="Select an option:" \
  --column="Option" \
  "1 - Create" \
  "2 - Skip" \
  "3 - Exit" \
  2>/dev/null)

if [ $? -ne 0 ]; then
  debug "Zenity dialog failed or was cancelled"
  exit 1
fi

debug "Selected choice: $choice"

case "$choice" in
"1 - Create")
  zenity --info --title="Result" --text="You chose to create!"
  ;;
"2 - Skip")
  zenity --info --title="Result" --text="You chose to skip."
  ;;
"3 - Exit")
  zenity --info --title="Result" --text="Exiting..."
  exit 0
  ;;
*)
  zenity --error --title="Error" --text="No valid choice made."
  exit 1
  ;;
esac
