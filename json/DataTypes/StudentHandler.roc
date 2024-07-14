module [readStudents]

import Student exposing [Student, Module]
import Decoding exposing [JsonDecoder, list, field, string, number, bool, map2]

Students : List Student

readStudents : JsonDecoder Students
readStudents = \json ->
    field (\s -> list readStudent s) json "students"

readStudent : JsonDecoder Student
readStudent = \json ->
    (field string json "name")
    |> Result.try \name -> (
            (field (\m -> list readModule m) json "modules")
            |> Result.try \modules -> Ok ({ name: name, modules: modules }))

readModule : JsonDecoder Module
readModule = \json ->
    (field string json "name")
    |> Result.try \name -> (
            (field number json "credits")
            |> Result.try \credits -> (
                    (field bool json "enrolled")
                    |> Result.try \enrolled -> Ok ({ credits: credits, name: name, enrolled: enrolled })
                ))
