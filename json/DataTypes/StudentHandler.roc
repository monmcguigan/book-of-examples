module [readStudents]

import Student exposing [Student, Module]
import Decoding exposing [JsonDecoder, list, field, string, number, bool, map2, map3]

Students : List Student

readStudents : JsonDecoder Students
readStudents = \json ->
    (field "students" (\s -> (list readStudent) s)) json

readStudent : JsonDecoder Student
readStudent = \json ->
    n = field "name" string
    (map2 n (field "modules" (\m -> (list readModule) m)) (\(name, mods) -> { name: name, modules: mods })) json

readModule : JsonDecoder Module
readModule = \json ->
    n = field "name" string
    c = field "credits" number
    e = field "enrolled" bool
    # Something I'm not entirely sure about is having to pass in json at the end of line 23. It's not intuitive to me what's going on 
    (map3 n c e \(name, creds, en) -> { name: name, credits: creds, enrolled: en }) json