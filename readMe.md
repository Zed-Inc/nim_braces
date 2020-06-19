# Nim Braces

Nim-Braces is a binary that allows you to write valid nim code with braces
This helps remove the need for whitespace indentation and helps people transition from braces indentation -> nim's whitespace indentation

## Process

The binary will parse your nim file, create a .tmp/ where the valid parsed
nim code is then transfered to before being executed with nimble
(and then deleted?)