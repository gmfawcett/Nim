discard """
errormsg: "cannot evaluate 'sizeof/alignof' because its type is not defined completely"
line: 9
"""

type
  MyStruct {.importc: "MyStruct".} = object

const i = sizeof(MyStruct)

echo i
