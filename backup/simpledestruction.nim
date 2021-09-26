import os, strutils

type
  O = object
    ss: seq[string]

proc `=destroy`(o: var O) =
  if (o.ss.len != 0):
    echo "destroying!"
  `=destroy`(o.ss)

proc makeO(num:int):O =
  var ss : seq[string]
  for i in 0..<num:
    ss.add("a string at index " & $i)
  result = O(ss:ss)

proc print(num:int):O =
  let o = makeO(num)
  for i in 0..<o.ss.len:
    echo o.ss[i]
  return o

proc printSink(o: sink O) =
  for i in 0..<o.ss.len:
    echo o.ss[i]

proc main() =
  echo "before"
  print(paramStr(1).parseInt)
  echo "after"

main()
