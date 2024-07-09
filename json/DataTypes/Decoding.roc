module [string, number, null, list, JsonDecoder, DecodingErrors]

import JsonData exposing [JsonData]

DecodingErrors : [
    StrErr Str,
    NumErr Str,
    NullErr Str,
    ArrErr Str
]

JsonDecoder t e : JsonData -> Result t e

string : JsonDecoder Str DecodingErrors # JsonData -> Result Str DecodingErrors
string = \json -> 
    when json is    
        String str -> Ok str
        _ -> Err (StrErr "Expected a String when decoding")

number : JsonDecoder U64 DecodingErrors
number = \json -> 
    when json is 
        Number num -> Ok num
        _ -> Err (NumErr "Expected a Number when decoding")

null : JsonDecoder Str DecodingErrors
null = \json -> 
    when json is 
        Null -> Ok "null"
        _ -> Err (NullErr "Expected a Null when decoding")
        
# list : JsonDecoder (List a) DecodingErrors
# list : JsonData -> Result (List a) DecodingErrors
# list : JaonData (JsonDecoder a DecodingErrors) -> JsonDecoder (List a) DecodingErrors
list : (elem -> Result ok [ArrErr Str]a), [Arr (List elem)]* -> Result (List ok) [ArrErr Str]a
list = \f, json -> 
    when json is 
        Arr jsonValues -> List.mapTry jsonValues f
        _ -> Err (ArrErr "Expected an Arr when decoding")
