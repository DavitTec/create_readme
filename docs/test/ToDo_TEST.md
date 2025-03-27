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
- **NAME**: create_readme.sh|state:unknown|version:0.0.0|size:5850|docs:./docs/test/create_readme_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/create_readme_Readme.md|readme_version:unknown|dev_doc:./docs/test/create_readme_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:
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
- **LOCATION**: ./scripts/create_readme.sh


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [create_readme.sh|state:unknown|version:0.0.0|size:5850|docs:./docs/test/create_readme_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/create_readme_Readme.md|readme_version:unknown|dev_doc:./docs/test/create_readme_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:](./scripts/create_readme.sh) - version: , [docs](), state: "


### TEST for Script 2
- **NAME**: env_readme.sh|state:unknown|version:0.0.0|size:3284|docs:./docs/test/env_readme_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/env_readme_Readme.md|readme_version:unknown|dev_doc:./docs/test/env_readme_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:
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
- **LOCATION**: ./scripts/env_readme.sh


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [env_readme.sh|state:unknown|version:0.0.0|size:3284|docs:./docs/test/env_readme_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/env_readme_Readme.md|readme_version:unknown|dev_doc:./docs/test/env_readme_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:](./scripts/env_readme.sh) - version: , [docs](), state: "


### TEST for Script 3
- **NAME**: INSERT|state:unknown|version:0.0.0|size:2427|docs:./docs/test/INSERT_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/INSERT_Readme.md|readme_version:unknown|dev_doc:./docs/test/INSERT_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:
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
- **LOCATION**: ./scripts/INSERT


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [INSERT|state:unknown|version:0.0.0|size:2427|docs:./docs/test/INSERT_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/INSERT_Readme.md|readme_version:unknown|dev_doc:./docs/test/INSERT_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:](./scripts/INSERT) - version: , [docs](), state: "


### TEST for Script 4
- **NAME**: insert_readme.sh|state:unknown|version:0.0.0|size:2134|docs:./docs/test/insert_readme_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/insert_readme_Readme.md|readme_version:unknown|dev_doc:./docs/test/insert_readme_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:
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
- **LOCATION**: ./scripts/insert_readme.sh


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [insert_readme.sh|state:unknown|version:0.0.0|size:2134|docs:./docs/test/insert_readme_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/insert_readme_Readme.md|readme_version:unknown|dev_doc:./docs/test/insert_readme_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:](./scripts/insert_readme.sh) - version: , [docs](), state: "


### TEST for Script 5
- **NAME**: test_caja.sh|state:unknown|version:0.0.0|size:2164|docs:./docs/test/test_caja_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_caja_Readme.md|readme_version:unknown|dev_doc:./docs/test/test_caja_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:
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
- **LOCATION**: ./scripts/test_caja.sh


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [test_caja.sh|state:unknown|version:0.0.0|size:2164|docs:./docs/test/test_caja_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_caja_Readme.md|readme_version:unknown|dev_doc:./docs/test/test_caja_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:](./scripts/test_caja.sh) - version: , [docs](), state: "


### TEST for Script 6
- **NAME**: test_caja_zenity.sh|state:unknown|version:0.0.0|size:3267|docs:./docs/test/test_caja_zenity_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_caja_zenity_Readme.md|readme_version:unknown|dev_doc:./docs/test/test_caja_zenity_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:
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
- **LOCATION**: ./scripts/test_caja_zenity.sh


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [test_caja_zenity.sh|state:unknown|version:0.0.0|size:3267|docs:./docs/test/test_caja_zenity_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_caja_zenity_Readme.md|readme_version:unknown|dev_doc:./docs/test/test_caja_zenity_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:](./scripts/test_caja_zenity.sh) - version: , [docs](), state: "


### TEST for Script 7
- **NAME**: test_readme.sh|state:unknown|version:0.0.0|size:2567|docs:./docs/test/test_readme_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_readme_Readme.md|readme_version:unknown|dev_doc:./docs/test/test_readme_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:
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
- **LOCATION**: ./scripts/test_readme.sh


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [test_readme.sh|state:unknown|version:0.0.0|size:2567|docs:./docs/test/test_readme_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_readme_Readme.md|readme_version:unknown|dev_doc:./docs/test/test_readme_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:](./scripts/test_readme.sh) - version: , [docs](), state: "


### TEST for Script 8
- **NAME**: test_script.sh|state:unknown|version:0.0.0|size:93|docs:./docs/test/test_script_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_script_Readme.md|readme_version:1.0.1|dev_doc:./docs/test/test_script_Developer.md|dev_doc_version:1.0.2|help_version:1.0.3|case_notes:
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

echo "  - [ ] develop a [test_script.sh|state:unknown|version:0.0.0|size:93|docs:./docs/test/test_script_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_script_Readme.md|readme_version:1.0.1|dev_doc:./docs/test/test_script_Developer.md|dev_doc_version:1.0.2|help_version:1.0.3|case_notes:](./scripts/test_script.sh) - version: , [docs](), state: "


### TEST for Script 9
- **NAME**: test_zenity.sh|state:unknown|version:0.0.0|size:992|docs:./docs/test/test_zenity_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_zenity_Readme.md|readme_version:unknown|dev_doc:./docs/test/test_zenity_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:
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
- **LOCATION**: ./scripts/test_zenity.sh


Check format:
## TODO To fix Check format section line 143 (a) or (b) in update_TODO.sh
# resolve (a)- [ ] develop a [script_name](script_location)-version([docs](docs_path)) state
# resolve (b)- [ ] develop a [script_name](script_location) - version: version, [docs](docs_path), state: state.

echo "  - [ ] develop a [test_zenity.sh|state:unknown|version:0.0.0|size:992|docs:./docs/test/test_zenity_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/test_zenity_Readme.md|readme_version:unknown|dev_doc:./docs/test/test_zenity_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:](./scripts/test_zenity.sh) - version: , [docs](), state: "


### TEST for Script 10
- **NAME**: update_TODO.sh|state:unknown|version:0.0.0|size:5435|docs:./docs/test/update_TODO_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/update_TODO_Readme.md|readme_version:unknown|dev_doc:./docs/test/update_TODO_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:
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

echo "  - [ ] develop a [update_TODO.sh|state:unknown|version:0.0.0|size:5435|docs:./docs/test/update_TODO_help.md|author:Davit Mullins (x/@_davit github@DavitTec)|readme:./docs/test/update_TODO_Readme.md|readme_version:unknown|dev_doc:./docs/test/update_TODO_Developer.md|dev_doc_version:unknown|help_version:unknown|case_notes:](./scripts/update_TODO.sh) - version: , [docs](), state: "

