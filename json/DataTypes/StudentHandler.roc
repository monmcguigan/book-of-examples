module [readStudents]

import Student exposing [Student, Module]
import Decoding exposing [JsonDecoder, list, field, string, number, bool, map2, map3]

Students : List Student

readStudents : JsonDecoder Students
readStudents = \json ->
    studentsField = \s -> (list readStudent) s
    (field "students" studentsField) json

readStudent : JsonDecoder Student
readStudent = \json ->
    nameField = field "name" string
    modulesField = field "modules" (\m -> (list readModule) m)
    (map2 nameField modulesField (\(name, mods) -> { name: name, modules: mods })) json

readModule : JsonDecoder Module
readModule = \json ->
    nmaeField = field "name" string
    creditsField = field "credits" number
    enrolledField = field "enrolled" bool
    (map3 nmaeField creditsField enrolledField \(name, credits, enrolled) -> { name: name, credits: credits, enrolled: enrolled }) json
