import terminal
import json
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





proc parseJsonFile*(filepath: string): tuple =
  echo "parsing syntax file"
  var file = filepath.open()
  var json = parseJson(file.readAll())
  var syntax: tuple[func_open: string, func_close: string, f_open: string, f_close:string, w_open:string, w_close:string]
  # initalise the tuple
  syntax = (func_open  : json["function-opening"].getStr, 
            func_close : json["function-closing"].getStr,  
            f_open     : json["for-open"].getStr,
            f_close    : json["for-close"].getStr,
            w_open     : json["while-open"].getStr,
            w_close    : json["while-close"].getStr
            )
  return syntax




#[
  Parsing the nim files passed in
  we need to account for using those other things on functions {.gcsafe, .header etc...}
  we can do so by checking if the brace we are currently on is the last brace on the line, and there are no characters next to it
]#
proc parseNimFile*(nimFiles: seq[string], syntax: tuple) =
  var readFiles: seq[string]
  var newFile: string = ""
  const
    indentSize = 2
  
  for i in 0..<nimFiles.len:
    try:
      readFiles.add(readAll(open(nimFiles[i])))
    except IOError:
     discard

  # make our .tmp/ directory
  let directory = os.getCurrentDir()
  let newPath = directory & ".tmp/"
  os.createDir(newPath)
  os.setCurrentDir(os.getCurrentDir() & ".tmp/")

  var toWrite: File

  for i,file in readFiles:
    toWrite = open(os.getCurrentDir() & nimFiles[i], fmWrite)
    for character in file:
      if character == syntax.func_open and character.next == " " or "": # we have found our opening bracket
        newFile.add("=\n" & indentSize) # add a new line and the defined indent size
        
      else:
        newFile.add(character)
        


  # while true:




# why am i getting a complex statement error?
proc executeNimFiles*(files: seq[string]): bool =

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

    