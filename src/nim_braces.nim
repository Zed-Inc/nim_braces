# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.


import os, strutils

import terminal
import json
import strutils
from os import nil

# print updates to the console with colourful keywords
proc printInfo*(contents: string, infoType: int, output = stdout) = 
  case infoType:
  of 1:
    setForegroundColor(output,fgMagenta,true)
    output.write("[ERROR]  ::  ")
    resetAttributes(output)
    output.writeLine(contents)
  else:
    discard



type
  # store the string that is our syntax
  Syntax = object
    func_open  : string
    func_close : string
    for_open   : string
    for_close  : string 
    while_open : string
    while_close: string
      


## Parse our Syntax.json file and return a named tuple of our valid syntax
proc parseJsonFile*(filepath: string): Syntax =
  echo "parsing syntax file"
  # parse the json file directly to an object
  var syntax = to((parseJson(open(filepath).readAll)), Syntax)

  return syntax
  # var syntax: tuple[func_open: string, func_close: string, f_open: string, f_close:string, w_open:string, w_close:string]
  # # initalise the tuple
  # syntax = (func_open  : json["function-opening"].getStr, 
  #           func_close : json["function-closing"].getStr,  
  #           f_open     : json["for-open"].getStr,
  #           f_close    : json["for-close"].getStr,
  #           w_open     : json["while-open"].getStr,
  #           w_close    : json["while-close"].getStr
            

  


#[
  Parsing the nim files passed in
  we need to account for using those other things on functions {.gcsafe, .header etc...}
  we can do so by checking if the brace we are currently on is the last brace on the line, and there are no characters next to it
]#
proc parseNimFile(nimFiles: seq[string], syntax: Syntax): bool =
  var 
    # store the contents of each file we open to parse
    readFiles  : seq[string]
  
    # store our changed files
    newFiles   : seq[string]
  
    # temporary variable to store our changed file
    fileParsed : seq[string]
    currLine   : string
    changedLine: string
    keyWord    : string
  
  # const indentSize:int = 2
  
  # 
  for i in 0..<nimFiles.len:
    try:
      readFiles.add(readAll(open(nimFiles[i])))
    except IOError:
     discard

  # make our .tmp/ directory
  # let directory = os.getCurrentDir()
  # let newPath = directory & ".tmp/"
  # os.createDir(newPath)
  # os.setCurrentDir(os.getCurrentDir() & ".tmp/")


  # the output file we will be writing to 
  # var toWrite: File

  for i,file in readFiles:
    # open the output file with the correct name
    # try:
    #   toWrite = open(os.getCurrentDir() & nimFiles[i], fmWrite)
    # except IOError:
    #   printInfo("failed to create/open file " & nimFiles[i],1)
    #   # assert os.execShellCmd("cd ..") == 0 
    #   return false
    fileParsed = file.splitLines
    echo "parsing file: " & nimFiles[i]
    # loop thorough the sequence of lines
    for line in fileParsed:
      currLine = line

      #[
        For the for loops and while loops we need to chop off all whitespace from the start and end
      #]#
      #--------- FOR LOOP CHECKS ----------->
      if currLine.strip.startswith("for") and currLine.endsWith(syntax.for_open):
        currLine[currLine.len - 2] = ':'
        currLine[currLine.len - 1] = '\n'
        keyWord = "for"
      elif currLine.strip.endsWith(syntax.for_close) and keyWord == "for":
        echo "removing closing brace of for loop" #DEBUG
        currLine[currLine.len - 1] = '\n'
      #------------------------------------->
      #--------- WHILE LOOP CHECKS ----------->
      elif currLine.strip.startswith("while") and currLine.endsWith(syntax.while_open):
        currLine[currLine.len - 2] = ':'
        currLine[currLine.len - 1] = '\n'
        echo "removing opening brace of while loop" # DEBUG
        keyWord = "while"
      elif currLine.strip.endsWith(syntax.while_close) and keyWord == "while":
        echo "removing closing brace of while loop" #DEBUG
        currLine[currLine.len - 1] = '\n'
      #-------------------------------------->

      #---------PROC FUNCTION CHECKS-------->
      elif currLine.startsWith("proc") and currLine.endsWith(syntax.func_open):
        echo "checking for proc function: line length " & $currLine.len #DEBUG
        currLine[currLine.len - 2] = '='
        currLine[currLine.len - 1] = '\n'
        keyWord = "proc"
      elif currLine.strip.endsWith(syntax.func_close) and keyWord == "proc":
        echo "removing closing brace of function: line length " & $currLine.len #DEBUG
        currLine[currLine.len - 1] = '\n' # delete the func_close char that was here
      #------------------------------------>
      #---------COMMENT CHECK--------------->
      # skip any line that starts with the comment symbol
      elif currLine.strip.startsWith("#"):
        continue
      #----------------------------------->
      else:
       currLine.add('\n')
      
      changedLine.add(currLine)
      currLine = "" # clear the lines
    # add the edited line to the parsed files 
    echo changedLine
    newFiles.add(changedLine)
    changedLine = ""
    # echo currLine
    

  try:
    # create our .tmp/ directory in the src folder
    echo "current direcotry: " & os.getCurrentDir()
    os.createDir(os.getCurrentDir() & "/convertedFiles/")
    os.setCurrentDir("convertedFiles") # move into our newly created direcotry
    echo "new directory: " & os.getCurrentDir()
  except OSError:
    printInfo("directory could not be created",1)
    return false

  var file: File
  for index,current in newFiles:
    try:
      file = open(nimFiles[index],fmWrite)
      file.write(current)
    except IOError:
      printInfo("file could not be created",1)
      return false
  
  echo "\nConverted files have been created in " & os.getCurrentDir()




  return true
#------FUNCTION END------>




# future feature?
proc executeNimFiles(files: seq[string]): bool =

  var command: string = "nim c -r "
  # var nimFiles: seq[string]
  
  os.setCurrentDir(os.getCurrentDir() & ".tmp/")

  for f in files:
    command = command & f & " "

  # # get all of our converted nim files
  # for f in os.walkFiles("/*.nim"):
  #   nimFiles.add(f)

  # #loop through the sequence and add our files to it
  # for i in nimFiles:
  #   command = command & i & " "

  # run our nim compile command and cd back up to our main directory and delete the .tmp direcotry
  # there's probably a cleaner way to move back up out of the directory 
  if os.execShellCmd(command) == 0:
    assert os.execShellCmd("cd ..") == 0
    os.removeDir(".tmp")
    return true
  else:
    assert os.execShellCmd("cd ..") == 0
    os.removeDir(".tmp")
    printInfo("Files could not be compiled!, .tmp/ will be deleted",1)

    return false

    

#-------------MAIN PROGRAM-------------------->
if commandLineParams().contains("--help"):
  echo """
  Nim braces is a CLI to convert nim code with braces to nim code without braces
  Syntax is defined in a json file called 'syntax.json' in some location of which i dont know where

  Usage
    'braces->nim {FILE NAMES HERE}'
    Where '{FILE NAMES HERE}' is the name of your nim source code files which have 
    said braces in it or really anything you want as opening/closing brackets
    this can all be easily changed in the 'syntax.json' file when you find it


  Some bugs/features?
    - indentation is not forced, this program uses the pre-existing indentation of the file 
    - make sure there is a gap/space between the end of your proc/if/while/for loop defintion and the opening 
      brace of the function/loop other wise the last letter WILL BE CHOPPED OFF

  """
var filesToParse = commandLineParams() # get all the files passed in

var jsonSyntax = parseJsonFile("syntax.json") # parse the json file storing our syntax

assert parseNimFile(filesToParse, jsonSyntax)

# assert executeNimFiles(filesToParse)