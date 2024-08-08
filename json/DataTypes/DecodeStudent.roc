module [readStudents]

import Student exposing [Student, Module]
import Decoding exposing [JsonDecoder, list, field, string, number, bool, map2, map3, or, oneOf, tag]

Students : List Student
Modules : List Module

readStudents : JsonDecoder Students
readStudents = \json ->
    studentsField = \s -> (list readStudent) s
    (field "students" studentsField) json

readStudent : JsonDecoder Student
readStudent = \json ->
    nameField = field "name" string
    gradeField = field "grade" number
    currentStudent = map3 nameField readModules gradeField 
        \name, modules, grade -> CurrentStudent { name, modules, grade }
    graduatedStudent = map3 nameField readModules gradeField 
        \name, modules, grade -> GraduatedStudent { name, modules, grade }
    studentDecoders = 
        Dict.empty {}
        |> Dict.insert "currentStudent" currentStudent 
        |> Dict.insert "graduatedStudent" graduatedStudent
    (tag studentDecoders) json

readModules : JsonDecoder Modules
readModules = \json -> 
    moduleField = \m -> (list readModule) m
    (field "modules" moduleField) json

readModule : JsonDecoder Module
readModule = \json ->
    nameField = field "name" string
    creditsField = field "credits" number
    enrolledField = field "enrolled" bool
    (map3 nameField creditsField enrolledField 
        \name, credits, enrolled -> { name, credits, enrolled }) json