module [JsonData]

JsonData : [
    String Str,
    Number U64,
    Null,
    Object (Dict Str JsonData),
    Arr (List JsonData),
]