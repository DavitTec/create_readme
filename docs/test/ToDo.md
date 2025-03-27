# Todo

## Tasks

object 

echo
1 "name:$name|
2 state:$state|
3 version:$version|
4 size:$size|
5 docs:$docs|
6 author:$author"


This is a TEST file to check capture and replacement of all variables

---- **TEST** ----

### TEST for 1st Script

Replace **NAME:** §SCRIPT_NAME(1) with the filename
Replace **STATE:** §SCRIPT_STATE(1) with the state (or "unknown")
Replace **VERSION:** §VERSION(1) with the version number
Replace **LOCATION:** §SCRIPT_LOCATION(1) with the file path
Replace **DOCS:** §SCRIPT_DOCS(1) with documentation link (currently empty)
Replace **AUTHOR:** §SCRIPT_AUTHOR(1) author (currently empty)

Check format: 
  - [ ] develop a [§SCRIPT_NAME(1)](§SCRIPT_LOCATION(1))-§VERSION(1)([docs](§SCRIPT_DOCS(1) )) (§SCRIPT_STATE(1))

---
### TEST for 2nd Script

Replace **NAME:** §SCRIPT_NAME(2) with the filename
Replace **STATE:**  §SCRIPT_STATE(2) with the state (or "unknown")
Replace **VERSION:** §VERSION(2) with the version number
Replace **LOCATION:** §SCRIPT_LOCATION(2) with the file path
Replace **DOCS:** §SCRIPT_DOCS(2) with documentation link (currently empty)


### TEST for 2nd Script

Replace **NAME:** §SCRIPT_NAME(n) with the filename
Replace **STATE:**  §SCRIPT_STATE(n) with the state (or "unknown")
Replace **VERSION:** §VERSION(n) with the version number
Replace **LOCATION:** §SCRIPT_LOCATION(n) with the file path
Replace **DOCS:** §SCRIPT_DOCS(n) with documentation link (currently empty)



..

..

---
### TEST for unknown or 99th Script

Replace **NAME:** §SCRIPT_NAME(99) with the filename
Replace **STATE:**  §SCRIPT_STATE(99) with the state (or "unknown")
Replace **VERSION:** §VERSION(99) with the version number
Replace **LOCATION:** §SCRIPT_LOCATION(99) with the file path
Replace **DOCS:** §SCRIPT_DOCS(99) with documentation link (currently empty)
