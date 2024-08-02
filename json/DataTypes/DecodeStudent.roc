module [readStudents]

import Student exposing [Student, Module]
import Decoding exposing [JsonDecoder, list, field, string, number, bool, map2, map3, or, oneOf]

Students : List Student

readStudents : JsonDecoder Students
readStudents = \json ->
    studentsField = \s -> (list readStudent) s
    (field "students" studentsField) json

readStudent : JsonDecoder Student
readStudent = \json ->
    nameField = field "name" string
    modulesField = field "modules" (\m -> (list readModule) m)
    currentGrade = field "currentGrade" number
    finalGrade = field "finalGrade" number
    currentStudent = map3 nameField modulesField currentGrade (\(name, mods, cg) -> CurrentStudent { name: name, modules: mods, currentGrade: cg })
    graduatedStudent = map3 nameField modulesField finalGrade (\(name, mods, fg) -> GraduatedStudent { name: name, modules: mods, finalGrade: fg })
    (oneOf [currentStudent, graduatedStudent]) json

readModule : JsonDecoder Module
readModule = \json ->
    nameField = field "name" string
    creditsField = field "credits" number
    enrolledField = field "enrolled" bool
    (map3 nameField creditsField enrolledField \(name, credits, enrolled) -> { name: name, credits: credits, enrolled: enrolled }) json
