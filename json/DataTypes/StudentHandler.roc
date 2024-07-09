module [getListStudents]

# import JsonData exposing [JsonData]
import Student exposing [Student, Module]
import Decoding exposing [JsonDecoder, list]

JsonErrors : [
    FieldNotFound Str,
    ExpectedJsonObject Str,
    ExpectedJsonArray Str,
]

Students : List Student
Modules : List Module

# getListStudents : JsonData -> Result (List Student) JsonErrors
getListStudents : JsonDecoder Students JsonErrors
getListStudents = \json ->
    when json is
        Object obj ->
            Dict.get obj "students"
            |> Result.try \s -> list checkStudentObj s # Result a err, (a -> Result b err) -> Result b err
            |> Result.onErr \_ -> Err (FieldNotFound "Expected field with name \"students\" in object") # Result a err, (err -> Result a otherErr) -> Result a otherErr

        _ -> Err (ExpectedJsonObject "Expected an Object")

# checkStudentList : JsonData -> Result (List Student) JsonErrors
checkStudentList : JsonDecoder Students JsonErrors
checkStudentList = \json ->
    when json is
        Arr students ->
            List.mapTry (List.map students checkStudentObj) \x -> x

        _ -> Err (ExpectedJsonArray "Expected an Array")

# checkStudentObj : JsonData -> Result Student JsonErrors
checkStudentObj : JsonDecoder Student JsonErrors
checkStudentObj = \json ->
    when json is
        Object obj ->
            when Dict.get obj "name" is
                Ok (String name) ->
                    Dict.get obj "modules"
                    |> Result.try \m -> (list checkModuleObj m)
                    |> Result.try \modules -> Ok ({ name: name, modules: modules })
                    |> Result.onErr \_ -> Err (FieldNotFound "Expected field with name \"modules\" in object")
                    
                _ -> Err (FieldNotFound "Expected field with name \"name\" in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")

# checkModulesList : JsonData -> Result (List Module) JsonErrors
checkModulesList : JsonDecoder Modules JsonErrors
checkModulesList = \json ->
    when json is
        Arr modules ->
            List.mapTry (List.map modules checkModuleObj) \x -> x

        _ -> Err (ExpectedJsonArray "Expected an Array")

# checkModuleObj : JsonData -> Result Module JsonErrors
checkModuleObj : JsonDecoder Module JsonErrors
checkModuleObj = \json ->
    when json is
        Object obj ->
            when Dict.get obj "name" is
                Ok (String name) ->
                    when Dict.get obj "credits" is
                        Ok (Number credits) ->
                            Ok ({ credits: credits, name: name })

                        _ -> Err (FieldNotFound "Expected field with name \"credits\" in object")

                _ -> Err (FieldNotFound "Expected field with name \"name\" in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")

