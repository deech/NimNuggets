import std/[asynchttpserver, asyncfutures, asyncdispatch, json, uri, os, strutils]

proc handle(r:Request):Future[void] =
  let msg = %* { "result": r.url.path.splitFile().name.toUpperAscii()}
  r.respond(Http200, $msg & "\n")

waitFor newAsyncHttpServer().serve(Port(8000), handle)
