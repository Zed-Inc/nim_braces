# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.


import os, strutils

import ./helpers

proc main() = 
  if commandLineParams().contains("--help"):
    echo """
    Nim braces is a CLI to convert nim code with braces to nim code without braces
    Syntax is defined in a json file called 'syntax.json' in some location of which i dont know where

    Usage
      'braces->nim {FILE NAMES HERE}'
      Where '{FILE NAMES HERE}' is the name of your nim source code files which have 
      said braces in it or really anything you want as opening/closing brackets
      this can all be easily changed in the 'syntax.json' file when you find it

    """
  var filesToParse = commandLineParams() # get all the files passed in
  var jsonSyntax = parseJsonFile("syntax.json") # parse the json file storing our syntax
  parseNimFile(filesToParse, jsonSyntax)
  assert executeNimFiles(filesToParse)
 
# enter main
main()