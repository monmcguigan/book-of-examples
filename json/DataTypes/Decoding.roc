module [string, number, null, list, bool, map, map2, field, andThen, JsonDecoder, JsonErrors]
import JsonData exposing [JsonData]

JsonErrors : [
    FieldNotFound Str,
    ExpectedJsonObject Str,
    ExpectedJsonArray Str,
    WrongJsonType Str,
    KeyNotFound,
]

JsonDecoder t : JsonData -> Result t JsonErrors

string : JsonDecoder Str # JsonData -> Result Str DecodingErrors
string = \json ->
    when json is
        String str -> Ok str
        _ -> Err (WrongJsonType "Expected a String when decoding")

number : JsonDecoder U64
number = \json ->
    when json is
        Number num -> Ok num
        _ -> Err (WrongJsonType "Expected a Number when decoding")

null : JsonDecoder Str
null = \json ->
    when json is
        Null -> Ok "null"
        _ -> Err (WrongJsonType "Expected a Null when decoding")

bool : JsonDecoder Bool
bool = \json ->
    when json is
        Boolean b -> Ok b
        _ -> Err (WrongJsonType "Expected a Bool when decoding")

# list : JsonDecoder (List a) DecodingErrors
# list : JsonData -> Result (List a) DecodingErrors
# list : JaonData (JsonDecoder a DecodingErrors) -> JsonDecoder (List a) DecodingErrors
# list : (elem -> Result ok [ArrErr Str]a), [Arr (List elem)]* -> Result (List ok) [ArrErr Str]a
# list : (()a -> b), JsonData -> JsonDecoder (List a)
# list : (elem -> Result a [ArrErr Str]a), [Arr (List elem)]* -> Result (List a) [ArrErr Str]a
list = \f, json ->
    when json is
        Arr jsonValues -> List.mapTry jsonValues f
        _ -> Err (ExpectedJsonArray "Expected an Arr when decoding")

field = \f, json, name ->
    when json is
        Object dict ->
            when Dict.get dict name is
                Ok v -> f v
                Err s -> Err s

        # Result.try (Dict.get dict name) \v -> f v
        _ -> Err (WrongJsonType "Expected an Object when decoding")

# map : (a -> b), JsonDecoder a, JsonDecoder b
map = \f, decoderA, jsonValue ->
    decoderA jsonValue
    |> Result.map f

map2 = \f, decoderA, decoderB, jsonValue ->
    when (decoderA jsonValue, decoderB jsonValue) is
        (Ok a, Ok b) -> Ok (f a b)
        (Err a, _) -> Err a
        (_, Err b) -> Err b
        _ -> Err "some other err"

# andThen : (a -> JsonDecoder b), JsonDecoder a, JsonData -> JsonDecoder b
andThen = \aDecoder, toB, json ->
    when aDecoder json is
        Ok a -> (toB a) json
        Err s -> Err s
# TESTS
mathsMod = Object
    (
        Dict.empty {}
        |> Dict.insert "name" (String "Maths 101")
        |> Dict.insert "credits" (Number 200)
    )
phyMod = Object
    (
        Dict.empty {}
        |> Dict.insert "name" (String "Physics 101")
        |> Dict.insert "credits" (Number 200)
    )
myString = String "hello"
otherStr = String "world"
myList = Arr [myString, otherStr]
boolVal = Boolean Bool.true

expect field string mathsMod "name" == Ok ("Maths 101")
expect field string myList "name" == Err (WrongJsonType "Expected an Object when decoding")
expect list string myList == Ok (["hello", "world"])
expect list string mathsMod == Err (ExpectedJsonArray "Expected an Arr when decoding")
expect string myString == Ok ("hello")
expect bool boolVal == Ok Bool.true
modules = Arr [mathsMod, phyMod]
