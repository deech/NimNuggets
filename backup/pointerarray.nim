type
  O = object
    s:cstring

proc makeOs(num: int): ptr UncheckedArray[O] =
  result = cast[ptr UncheckedArray[O]](alloc(num * sizeof(O)))
  for i in 0..<num:
    let
      s = "a string at index " & $i
      sc = cast[cstring](alloc(s.len+1))
    copyMem(unsafeAddr sc[0], unsafeAddr s[0], s.len+1)
    result[i] = O(s: sc)

let
  num = 10
  objs = makeOs(num)

for i in 0..<num:
  echo objs[i].s
  dealloc objs[i].s

dealloc objs
