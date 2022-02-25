# nim c --app:lib module.nim

type
  Instruction* = ref object
    ID*: string
    Response*: string

proc execute*(command: string, c: ptr Channel[int]) {.gcsafe, nimcall, exportc, dynlib.} =
  var instruction = Instruction(ID: "1", Response: command & "_executed")
  echo("in dynlib")
  # Deref and cast, without the deref it throws illegal mem
  # var chan = cast[Channel[int]](c[])
  # send the instruction back
  c[].send(1)
  echo("exiting dynlib")