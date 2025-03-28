#!/usr/bin/env bash
# src/ex_bash_rematch.sh
# version 0.0.1-9
# lng=en_GB  #(British English, Left to Right)

export LC_ALL=C.UTF-8

# TESTING with S1 = TEST1 to TEST4
TEST_1="Hello=Worl=Today"
TEST_2="HeLlo=Worl=dToday"
TEST_3="Hello=Wor=ld=Today"
TEST_4="Hello=w=rl=Today"

echo "___>testing for key value pairs"

# Function to split and modify key-value pairs
keyvalue() {
  local line=$1
  if [[ $line =~ = ]]; then
    # Find the position of the first '='
    first_eq=$(expr index "$line" "=")
    # Extract key and value
    key=${line:0:first_eq-1}
    value=${line:first_eq}
    # Replace '=' with '_' in value
    value=${value//=/_}
    echo "$key=$value"
  else
    echo "$line"
  fi
}

# Function to check pattern match and set global variables
checkPattern() {
  local string=$1
  pattern='^(h[a-z]+)=*(w[a-z_]+)$'
  if [[ $string =~ $pattern ]]; then
    matched="Yes"
    group1=${BASH_REMATCH[1]}
    group2=${BASH_REMATCH[2]}
  else
    matched="No"
    group1=
    group2=
  fi
}

# Print table headings
printf "%-10s | %-25s | %-15s | %-25s | %-25s | %-30s\n" \
  "Test Case" "Input String" "Key" "Value After Replacement" "Output After Processing" "Pattern Match (Expected)"
printf "%-10s | %-25s | %-15s | %-25s | %-25s | %-30s\n" \
  "----------" "--------------" "-----" "------------------------" "------------------------" "---------------------------"

# Loop through test cases
for ((i = 1; i <= 4; i++)); do
  mystring="TEST_$i"
  test_case=$mystring
  input_string=${!mystring}

  # Process the string using keyvalue function
  string=$(keyvalue "$input_string")
  key=${string%%=*}
  value_replaced=${string#*=}
  processed_string=${string,,}

  # Check the pattern
  checkPattern "$processed_string"

  # Construct pattern match column
  if [ "$matched" == "Yes" ]; then
    pattern_match="Match: groups '$group1', '$group2'"
  else
    pattern_match="Not found!"
  fi

  # Print the row
  printf "%-10s | %-25s | %-15s | %-25s | %-25s | %-30s\n" \
    "$test_case" "$input_string" "$key" "$value_replaced" "$processed_string" "$pattern_match"

  echo
done
