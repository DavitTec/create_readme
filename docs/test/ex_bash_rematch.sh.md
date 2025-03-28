## ex Bash REMATCH



version 0.0.1-1

```bash
#!/usr/bin/env bash

# src/ex_bash_rematch.sh

# version 0.0.1-1

# lng=en-GB  #(Right to left)

#TESTING with S1 = TEST1 to TEST5

TEST_1="Hello=Worl=Today"
TEST_2="HeLlo=Worl=dToday"
TEST_3="Hello=Wor=ld=Today"
TEST_4="Hello=w=rl=Today"
TEST_5="فتاحي = ليس كذلك = عظيم = اليوم"

## TEST 1

# Testing for "version" string as $1

# set 'kv' to "=" (as a  char(code))

# set input_string

# - convert to $1 lower case

# - determine $1 must include a 'kv' (max 1 in count)

# - strip $1 any hidden characters

# - determine $1 lenght must be less than max(25 char)

# -

# case check if $1 (left of 'kv') is

#  equal to "version",  do next

#  1) set testID equal to 1

#  2) set testID equal to 2

#  exit

#  not equal then exit

echo "___>testing for key value pairs"

# get key value pairs

keyvalue() {

  # Assume Left to Right languages

  local line=$1
  if [[ $line =~ = ]]; then
    key=${line%%=*}
    value=${line#*=}
    value=${value//=/§}
    echo "$key=$value"
  else
    echo "$line"
  fi
}

# Check for pattern match

checkPattern() {
  local string=$1
  echo -n "my string1= $string"
  pattern='(h[a-z]+)\=*(w[a-z]+)' #search pattern
  if [[ $string =~ $pattern ]]; then
    echo "Match found!"
    for i in "${!BASH_REMATCH[@]}"; do
      echo "$i: ${BASH_REMATCH[$i]}"
    done
  else
    echo "'$1' Not found!"
  fi
}

# Perform tests on strings

for ((i = 1; i < 6; i++)); do
  mystring="TEST_$i"

  #   checkPattern() string

  string="$(keyvalue ${!mystring})"
  string=${string,,}
  echo "check pattern before using: $string"
  checkPattern "$string"

  #  echo " The KEY is: ${!string}"

  # echo " The VALUE is: ${!string}"

  echo
done

#string="$(keyvalue $TEST_2)"
#string=${string,,}

#echo " The KEY is: $string"
```

