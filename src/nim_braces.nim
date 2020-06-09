# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.


import os

import ./helpers

proc main() = 
  var filesToParse = commandLineParams() # get all the files passed in
  let jsonSyntax = parseJsonFile("~/.config/nim_braces/syntax.json")
  parseNimFile(filesToParse, jsonSyntax)
  discard executeNimFiles(filesToParse)
 
# enter main
main()