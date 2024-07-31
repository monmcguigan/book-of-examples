module [Json]

Json : [
    String Str,
    Number U64,
    Boolean Bool,
    Object (Dict Str Json),
    Arr (List Json),
]