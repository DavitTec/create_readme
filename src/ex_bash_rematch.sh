#!/usr/bin/env bash
# src/ex_bash_rematch.sh
# version 0.0.1

echo "TEST 1"
string=$1                       # input string
pattern='(H[a-z]+)\s*(W[a-z]+)' #search pattern
if [[ $string =~ $pattern ]]; then
  echo "Match found!"
  for i in "${!BASH_REMATCH[@]}"; do
    echo "$i: ${BASH_REMATCH[$i]}"
  done
  else
   echo "'$1' Not found!"
fi
