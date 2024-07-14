module [JsonData]

JsonData : [
    String Str,
    Number U64,
    Boolean Bool,
    Null,
    Object (Dict Str JsonData),
    Arr (List JsonData),
]