{.emit:"""/*TYPESECTION*/
template <int N>
struct Factorial
{
    enum { value = N * Factorial<N - 1>::value };
};

template <>
struct Factorial<0>
{
    enum { value = 1 };
};
""".}

type
  Factorial[N : static[int]]{.importcpp: "Factorial<'0>".} = object

proc value(_:typedesc[Factorial]):cint {.importcpp: "'1::value@".}

echo Factorial[3].value + Factorial[3].value

# 12
