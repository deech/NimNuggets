type
  StdVector[T]{.importcpp: "std::vector<'0>", header:"<vector>".} = object
  StdUniquePtr[T]{.importcpp: "std::unique_ptr<'0>", header: "<memory>".} = object
  StdString{.importcpp: "std::string", header: "<string>".} = object

proc makeSVector[T](): StdVector[T] {.importcpp: "std::vector<'*0>(@)", header: "<vector>".}
proc add[T](v:StdVector[T],t:T) {.importcpp: "#.emplace_back(@)", header: "<vector>".}
proc getIndex[T](v:StdVector[T],idx:cint):T {.importcpp:"#[#]", header: "<vector>".}

proc makeUPtr[T](t:T):StdUniquePtr[T] {.importcpp: "std::make_unique<'*0>(@)", header: "<memory>".}
proc getInner[T](p:StdUniquePtr[T]):T {.importcpp: "(* #)", header:"<memory>".}

proc makeSString(c:cstring):StdString {.importcpp:"std::string(@)", header: "<string>".}
proc getString(a: StdString): cstring {.importcpp: "(char *)(#.c_str())", header: "<string>".}

proc makeVector(num:int):StdVector[StdUniquePtr[StdString]] =
  result = makeSVector[StdUniquePtr[StdString]]()
  for i in 0..<num:
    var s = cstring("string at index " & $i)
    result.add(makeUPtr(makeSString(s)))

let
  num = 10
  v = makeVector(10)

for i in 0..<num:
  echo v.getIndex(i.cint).getInner.getString
