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
    modulesField = field "modules" \m -> (list readModule) m
    currentGradeField = field "currentGrade" number
    finalGradeField = field "finalGrade" number
    currentStudent = map3 nameField modulesField currentGradeField 
        \name, modules, currentGrade -> CurrentStudent { name, modules, currentGrade }
    graduatedStudent = map3 nameField modulesField finalGradeField 
        \name, modules, finalGrade -> GraduatedStudent { name, modules, finalGrade }
    (oneOf [currentStudent, graduatedStudent]) json

readModule : JsonDecoder Module
readModule = \json ->
    nameField = field "name" string
    creditsField = field "credits" number
    enrolledField = field "enrolled" bool
    (map3 nameField creditsField enrolledField 
        \name, credits, enrolled -> { name, credits, enrolled }) json

readMod : JsonDecoder Module
readMod =\json -> 
    { map2 <-
        name: field "name" string,
        credits: field "credits" number,
        enrolled: field "enrolled" bool,
    }  json