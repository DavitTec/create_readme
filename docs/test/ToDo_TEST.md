# Todo
## Package Info
- Package Version: 0.0.7-7
- Repository: https://github.com/DavitTec/create_readme.git
- Author: Davit Mullins (x/@_davit github@DavitTec)
- Settings:
  - Case Sensitive: true
  - Localization: UK
  - Language: en-GB
  - Line Ending: LF

## Tasks
object 
echo
1 "name:§SCRIPT_NAME(0)|"
2 "state:§SCRIPT_STATE(0)|"
3 "version:§SCRIPT_VERSION(0)|"
4 "size:§SCRIPT_SIZE(0)|"
5 "docs:§SCRIPT_DOCS(0)|"
6 "author:§SCRIPT_AUTHOR(0)|"
7 "readme:§SCRIPT_README(0)|"
8 "readme_version:§SCRIPT_README_VERSION(0)|"
9 "dev_doc:§SCRIPT_DEV_DOC(0)|"
10 "dev_doc_version:§SCRIPT_DEV_DOC_VERSION(0)|"
11 "help_version:§SCRIPT_HELP_VERSION(0)|"
12 "location:§SCRIPT_LOCATION(0)|"

This is a TEST file to check capture and replacement of all variables

---- **TEST** ----

### TEST for Script 0
- **NAME**: unknown_script
- **STATE**: unknown
- **SCRIPT VERSION**: 0.0.0
- **SIZE**: 0
- **DOCS**: No documentation available
- **AUTHOR**: unknown_author
- **README**: No README available
- **README_VERSION**: unknown
- **DEV_DOC**: No developer doc available
- **DEV_DOC_VERSION**: unknown
- **HELP_VERSION**: unknown
- **LOCATION**: unknown_location


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [unknown_script](unknown_location) - version: 0.0.0, [docs](No documentation available), state: unknown"


### TEST for Script 1
- **NAME**: 
- **STATE**: 
- **SCRIPT VERSION**: 
- **SIZE**: 
- **DOCS**: 
- **AUTHOR**: 
- **README**: 
- **README_VERSION**: 
- **DEV_DOC**: 
- **DEV_DOC_VERSION**: 
- **HELP_VERSION**: 
- **LOCATION**: ./scripts/test_script.sh


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [](./scripts/test_script.sh) - version: , [docs](), state: "


### TEST for Script 2
- **NAME**: 
- **STATE**: 
- **SCRIPT VERSION**: 
- **SIZE**: 
- **DOCS**: 
- **AUTHOR**: 
- **README**: 
- **README_VERSION**: 
- **DEV_DOC**: 
- **DEV_DOC_VERSION**: 
- **HELP_VERSION**: 
- **LOCATION**: ./scripts/update_TODO.sh


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [](./scripts/update_TODO.sh) - version: , [docs](), state: "

