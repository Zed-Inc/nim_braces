# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.


import json, os

import ./helpers

proc main() = 
  var file: File
  var syntax: seq[char]
  var filesToParse = commandLineParams() # get all the file spassed in

  # try and open the file
  try:
    # is there a better location for this?
    file = open("~/.config/nim_braces/syntax.json")
  except IOError: 
    printInfo("config file could not be opened\n\t     config file located at: ~/.config/nim_braces/syntax.json",1)
    # is there a cleaner way to exit, so this is silent and doesn't display any messages?
    quit(QuitFailure)





# enter main
main()