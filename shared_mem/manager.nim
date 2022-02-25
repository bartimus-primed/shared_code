proc createSharedChannel*[T] (channel_type: typedesc[T]): ptr Channel[T] =
  # Create a shared channel of type T
  result = cast[ptr Channel[T]](
    allocShared0(sizeof(Channel[T]))
  )

# Might be useful to auto spawn a thread that waits for the channel empty
# proc peeker*[T](channel: ptr Channel[T]) {.nimcall, gcsafe.} =
#   while channel[].peek() > 0:
#     echo("waiting for empty channel before dealloc")
#   channel[].close()
#   deallocShared(channel)

proc deleteSharedChannel*[T] (channel: ptr Channel[T]): bool =
  # Check if channel has data in it, if so lets not delete it
  if channel[].peek() > 0:
    return false
  try:
    channel[].close()
    deallocShared(channel)
    echo("Manager Deleted Channel")
    result = true
  except:
    result = false