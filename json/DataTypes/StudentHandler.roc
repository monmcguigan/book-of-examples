module [getListStudents]

# import JsonData exposing [JsonData]
import Student exposing [Student, Module]
import Decoding exposing [JsonDecoder, list, map, map2, field, string, number]

Students : List Student

# getLS : JsonDecoder Students
getListStudents = \json ->
    field (\s -> list checkStudentObj s) json "students"

checkStudentObj = \json ->
    (field string json "name")
    |> Result.try \name -> (
            (field (\m -> list checkModuleObj m) json "modules")
            |> Result.try \modules -> Ok ({ name: name, modules: modules }))

checkModuleObj = \json ->
    (field string json "name")
    |> Result.try \name -> (
            (field number json "credits")
            |> Result.try \credits -> Ok ({ credits: credits, name: name }))

