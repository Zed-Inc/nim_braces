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





proc parseJsonFile*(file:File): tuple =
  echo "parsing syntax file"
  var json = parseJson(file.readAll())
  var syntax = tuple[func_open  : json["function-opening"].getStr, 
                     func_close : json["function-closing"].getStr,  
                     f_open     : json["for-open"].getStr,
                     f_close    : json["for-close"].getStr,
                     w_open     : json["while-open"].getStr,
                     w_close    : json["while-close"].getStr
                    ]
  return syntax




#[
  Parsing the nim files passed in
  we need to account for using those other things on functions {.gcsafe, .header etc...}
  we can do so by checking if the brace we are currently on is the last brace on the line, and there are no characters next to it
]#
proc parseNimFile*(nimFiles: seq[string], syntax: tuple): bool =
  var readFiles: seq[string]
  const
    indentSize = 2
  
  for i in 0..<nimFiles.len:
    try:
      readFiles.add(readAll(nimFiles[i]))
    except IOError:
     discard

  # make our .tmp/ directory
  let directory = os.getCurrentDir()
  let newPath = directory & ".tmp/"
  os.createDir(newPath)


  # while true:


  return true



proc executeNimFiles*(files: seq[string]): bool =
  var command = "nim c -r "
  var nimFiles: seq[string]
  
  # get all of our converted nim files
  for f in os.walkFiles(".tmp/*.nim"):
    nimFiles.add(f)

  #loop through the sequence and add our files to it
  for i in nimFiles:
    command = command & i & " "

  # run our nim compile command
  if (os.execShellCmd(command)) == 0:
    return true
  else:
    return false