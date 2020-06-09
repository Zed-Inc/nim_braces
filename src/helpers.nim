import terminal
import json

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





proc parseJsonFile*(file:File, syntaxDefined: seq[char]) =
  echo "parsing syntax file"


#[
  Parsing the nim files passed in
  we need to account for using those other things on functions {.gcsafe, .header etc...}
]#
proc parseNimFile*(nimFiles: seq[File]): bool =
  var readFiles: seq[string]
  for i in 0..<nimFiles.len:
    try:
      readFiles.add(readAll(nimFiles[i]))
    except IOError:
     discard

  return true
