
## test_readme.sh
-  VERSION="0.0.7"

-  Function for ENV START (
-  -  READ ENV
-  -  GET STATE ENV
-  -  SET STATE ENV
-  -  DELETE STATE ENV
-  / )  ENV  END

-  Function to DEBUG START (
-  -  Function to get ENV
-  -  Function to Debug (output to stderr)
-  / ) DEBUG  END

-  Function to DIAGNOSTIC START (
-  -  Function to get ENV
-  -  Function to get Context
-  -  Function to ensure templates (1 to many)
-  -  Function to ensure directories are set up
-  -  Function to ensure test directories exist
-  -  Function to Ensure Zenity is installed
-  -  Post-creation check
-  / ) DIAGNOSTIC END

-  Function to HELP START (
-  -  Check version of help texts
-  -  Function to show help

-  Function to get CONTEXT START (
-  -  get State
-  -  get context
-  -  Handle command line args first
-  -  list approach
-  -  Use Zenity
-  -  Use Caja
-  -  Use Terminal
-  -  Use Test
-  -  set context
-  / ) CONTEXT END

-  Function to CREATE START (
-  -  Function to get available templates
-  -  Function to create README
-  -  Function to recover README
-  -  Function to Delete README
-  / ) CREATE  END

-  Function for setting MENU  START (
-  -  With or without zenity
-  -  Get template choice
-  -  Function for Terminal MENU
-  -  Function for Zanity MENU
-  -  Function for TEST MENU
-  -  Function for HELP MENU
-  -  Function for DOCS MENU
-  -  Function for TEMPLATES MENU
-  / ) MENU  END

-  MAIN Function START (

-  / )  MAIN  END

-  Run Main
main function
main "$@"
-  Exit status
