import std/macros, std/sets, std/tables, std/sequtils

proc toPairs(a:NimNode):OrderedTable[string,NimNode] =
  let typ =
    case a.getType.getTypeImpl.kind
    of nnkBracketExpr: a.getType[1].getTypeImpl[2]
    else: a.getType.getTypeImpl
  for n in typ:
    result[n[0].strVal] = n[1]

proc diffTypeImpl(a:NimNode,b:NimNode):NimNode {.compileTime.} =
  let
    aPairs = toPairs(a)
    bPairs = toPairs(b)
  result = newNimNode(nnkTupleTy)
  for k,v in bPairs:
    if aPairs.contains(k):
      if aPairs[k].strVal != v.strVal:
        result.add(
          newIdentDefs(
            ident(k),
            nnkProcTy.newTree(
              nnkFormalParams.newTree(
                ident(v.strVal),
                newIdentDefs(
                  ident(k),
                  ident(aPairs[k].strVal)
                )
              ),
              newEmptyNode()
            )
          )
        )
    else:
      result.add(newIdentDefs(ident(k),ident(v.strVal)))

macro diffType*(a:typedesc,b:typedesc):untyped =
  diffTypeImpl(a,b)

macro migrateImpl(a:typed,b:typedesc,diff:typed):untyped =
  let
    akeys = a.getType.getTypeImpl[2].mapIt(it[0].strVal).toHashSet
    migr = toPairs(diff)
  result = nnkObjConstr.newTree(b.getType[1])
  for k in (aKeys - migr.keys.toSeq.toHashSet).toSeq:
    result.add(
      newColonExpr(
        ident(k),
        newDotExpr(ident(a.strVal),ident(k))
      )
    )
  for k,v in migr.pairs:
    if v.kind == nnkProcTy:
      result.add(
        newColonExpr(
          ident(k),
          newCall(
            newDotExpr(diff,ident(k)),
            newDotExpr(a,ident(k))
          )
        )
      )
    else:
      result.add(
        newColonExpr(
          ident(k),
          newDotExpr(diff,ident(k))
        )
      )

template migrate*(a:typed,b:typedesc,diff:typed):untyped =
  let tmp = a
  migrateImpl(tmp,b,diff)
