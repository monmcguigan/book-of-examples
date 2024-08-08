module [readStudents]

import JsonData exposing [Json]
import Student exposing [Student, Module]

JsonErrors : [
    FieldNotFound Str,
    ExpectedJsonObject Str,
    ExpectedJsonArray Str,
]

Students : List Student

readStudents : Json -> Result Students JsonErrors
readStudents = \json ->
    when json is
        Object obj ->
            when Dict.get obj "students" is
                Ok students -> checkStudentArr students
                Err KeyNotFound -> Err (FieldNotFound "Expected field with name students in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")

checkStudentArr : Json -> Result Students JsonErrors
checkStudentArr = \json ->
    when json is
        Arr students ->
            List.mapTry students readStudent

        _ -> Err (ExpectedJsonArray "Expected an Array")

readStudent : Json -> Result Student JsonErrors
readStudent = \json ->
    when json is
        Object obj ->
            when Dict.get obj "name" is
                Ok (String name) ->
                    when Dict.get obj "modules" is
                        Ok moduleArr ->
                            when checkModulesArr moduleArr is
                                Ok modules ->
                                    when Dict.get obj "grade" is
                                        Ok (Number grade) ->
                                            when Dict.get obj "#type" is
                                                Ok (String "currentStudent") -> Ok (CurrentStudent { name, modules, grade })
                                                Ok (String "graduatedStudent") -> Ok (GraduatedStudent { name, modules, grade })
                                                _ -> Err (FieldNotFound "Expected type discriminator field in object")

                                        _ -> Err (FieldNotFound "Expected field with name grade in object")

                                Err e -> Err e

                        _ -> Err (FieldNotFound "Expected field with name modules in object")

                _ -> Err (FieldNotFound "Expected field with name name in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")

checkModulesArr : Json -> Result (List Module) JsonErrors
checkModulesArr = \json ->
    when json is
        Arr modules ->
            List.mapTry modules readModule

        _ -> Err (ExpectedJsonArray "Expected an Array")

readModule : Json -> Result Module JsonErrors
readModule = \json ->
    when json is
        Object fields ->
            when Dict.get fields "name" is
                Ok (String name) ->
                    when Dict.get fields "credits" is
                        Ok (Number credits) ->
                            when Dict.get fields "enrolled" is
                                Ok (Boolean enrolled) ->
                                    Ok ({ name, credits, enrolled })

                                _ -> Err (FieldNotFound "Expected field with name \"credits\" in object")

                        _ -> Err (FieldNotFound "Expected field with name \"credits\" in object")

                _ -> Err (FieldNotFound "Expected field with name \"name\" in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")
