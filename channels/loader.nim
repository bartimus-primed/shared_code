import dynlib
import os
import threadpool
import ../shared_mem/manager

type
  Instruction* = ref object
    ID*: string
    Response*: string

# Import dynlib
{.push importc, dynlib: "libmodule.dylib", nimcall, gcsafe.}
proc execute(command: string, c: ptr Channel[int]) 
{.pop.}

# Set up the channel
var chanPtr = createSharedChannel(int)
chanPtr[].open()
# Call the imported proc.
while true:
  execute("ls", chanPtr)
  let response = chanPtr[].tryRecv()
  if response.dataAvailable:
    echo(response.msg)
  sleep(2000)
# Wait for response

# Echo the response