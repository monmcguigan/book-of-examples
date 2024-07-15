module [string, number, null, bool, list, field, map, map2, map3, andThen, JsonDecoder, DecodingErrors]
import JsonData exposing [JsonData]

DecodingErrors : [
    FieldNotFound Str,
    ExpectedJsonObject Str,
    ExpectedJsonArray Str,
    WrongJsonType Str,
    KeyNotFound
]

JsonDecoder t : JsonData -> Result t DecodingErrors

string : JsonDecoder Str
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

list : JsonDecoder a -> JsonDecoder (List a)
list = \decoderA ->
    \data ->
        when data is
            Arr jsonValues -> List.mapTry jsonValues decoderA
            _ -> Err (ExpectedJsonArray "Expected an Arr when decoding")

field : Str, JsonDecoder a -> JsonDecoder a
field = \name, decoder ->
    \data ->
        when data is
            Object dict ->
                when Dict.get dict name is
                    Ok v -> decoder v
                    Err s -> Err s

            _ -> Err (WrongJsonType "Expected an Object when decoding")

map : JsonDecoder a, (a -> b) -> JsonDecoder b
map = \decoderA, f ->
    \data -> Result.map (decoderA data) f
# \data -> decoderA data |> Result.map f
# decoderA |> Result.map f

map2 : JsonDecoder a, JsonDecoder b, ((a, b) -> c) -> JsonDecoder c
map2 = \decoderA, decoderB, f ->
    \data ->
        when (decoderA data, decoderB data) is
            (Ok a, Ok b) -> Ok (f (a, b))
            (Err a, _) -> Err a
            (_, Err b) -> Err b

map3 : JsonDecoder a, JsonDecoder b, JsonDecoder c, ((a, b, c) -> d) -> JsonDecoder d
map3 = \decoderA, decoderB, decoderC, f ->
    \data ->
        when (decoderA data, decoderB data, decoderC data) is
            (Ok a, Ok b, Ok c) -> Ok (f (a, b, c))
            (Err a, _, _) -> Err a
            (_, Err b, _) -> Err b
            (_, _, Err c) -> Err c

andThen : (a -> JsonDecoder b), JsonDecoder a -> JsonDecoder b
andThen = \toB, aDecoder  ->
    \data -> 
        when aDecoder data is
            Ok a -> (toB a) data
            Err a -> Err a

# TESTS
mathsMod = Object
    (
        Dict.empty {}
        |> Dict.insert "name" (String "Maths 101")
        |> Dict.insert "credits" (Number 200)
        |> Dict.insert "enrolled" (Boolean Bool.true)
    )
phyMod = Object
    (
        Dict.empty {}
        |> Dict.insert "name" (String "Physics 101")
        |> Dict.insert "credits" (Number 200)
    )
nameDecoder = field "name" string
creditsDecoder = field "credits" number
enrolledDecoder = field "enrolled" bool

# map tests
expect (map nameDecoder \name -> { name: name }) phyMod == Ok ({ name: "Physics 101" })
expect (map enrolledDecoder \name -> { name: name }) phyMod == Err(KeyNotFound)

# map2 tests
expect (map2 nameDecoder creditsDecoder \(name, credits) -> { name: name, credits: credits }) (phyMod) == Ok ({ name: "Physics 101", credits: 200 })

# map3 tests
expect (map3 nameDecoder creditsDecoder enrolledDecoder \(name, credits, enrolled) -> { name: name, credits: credits, enrolled: enrolled }) (mathsMod) == Ok ({ name: "Maths 101", credits: 200, enrolled: Bool.true })

# list tests
myList = Arr [String "hello", String "world"]
expect (list string) myList == Ok (["hello", "world"])
expect (list string) mathsMod == Err (ExpectedJsonArray "Expected an Arr when decoding")

# field tests
expect nameDecoder mathsMod == Ok ("Maths 101")
expect nameDecoder myList == Err (WrongJsonType "Expected an Object when decoding")
expect (field "blah" string) mathsMod == Err KeyNotFound

# primitive types
expect string (String "hello") == Ok ("hello")
expect bool (Boolean Bool.true) == Ok Bool.true
expect number (Number 400) == Ok (400)
expect null (Null) == Ok ("null")
