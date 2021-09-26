proc fizzbuzz():seq[string] =
  for i in 0..<100:
    let
      fizz = i mod 3 == 0
      buzz = i mod 5 == 0
    result.add(
      if fizz and buzz: "fizzbuzz"
      elif fizz: "fizz"
      elif buzz: "buzz"
      else: $i
    )

echo fizzbuzz()
